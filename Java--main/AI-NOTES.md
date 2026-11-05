# AI-NOTES —— 项目启动手册（AI 专用备忘）

> 本文件写给 AI 助手自己看：下次会话遇到"启动项目 / 连不上后端"时，**直接按本手册执行，不要重新排查**。
> 电脑每次重置后 node_modules、target 会被删除，但 .m2、MySQL、项目源码都保留。

## 目录结构（2026-11-05 现状）

```
Java--main/
├── backend-8081/        后端 Spring Boot 工程（纯 API，无静态页面）
├── frontend-5173/       前端 Vue3 + Vite 工程（纯 Vue，入口仅 index.html）
├── springboottest.sql   数据库结构 + 数据快照（7 表，含全部内容数据）
├── AI-NOTES.md          本文件
├── README.md            项目简介
├── start-all.bat        一键启动（自包含，不依赖 ps1）
├── stop-all.bat         一键停止（自包含，按端口杀进程）
├── start-backend.bat    仅启动后端
└── start-frontend.bat   仅启动前端
```

> 注意：所有 .bat 均为 **GBK 编码**（用 iconv 或 Python encode('gbk') 生成），改脚本必须保持 GBK，否则中文乱码。
> 早期的 start-all.ps1 / stop-all.ps1 已废弃删除，bat 全部自包含，不再调用任何 ps1。
> 单文件版 Luffy.html、OnePiece.html 已全部转换为 Vue 组件并删除，项目是纯 Vue。

## 一、最快启动方式（优先推荐）

让用户双击 `D:\workSpace\Java-\Java--main\` 下的脚本：

| 脚本 | 作用 |
|------|------|
| `start-all.bat` | 一键入口：数据库自检 → 后端编译检查 → 启动后端(8081)+前端(5173) → 健康检查 → 开浏览器 |
| `stop-all.bat` | 一键停止：按端口 8081/5173 杀进程 |
| `start-backend.bat` | 只启动后端（缺 target 自动 mvnw 编译） |
| `start-frontend.bat` | 只启动前端（缺 node_modules 自动 npm ci） |

## 二、如果 AI 要自己动手（无脚本场景），按此顺序执行

1. **构建后端**：优先用 `mvnw.cmd`（本机实测可用）：
   ```
   cd D:/workSpace/Java-/Java--main/backend-8081
   ./mvnw.cmd -s maven-settings.xml -DskipTests package
   ```
   （AI-NOTES 旧版曾记 mvnw 在 Git Bash 下有 bug，需用 java 直调 classworlds；但 2026-11-05 实测 `./mvnw.cmd` 在 Git Bash 下正常，BUILD SUCCESS。若遇到 classworlds Launcher 报错，再回退到 java 直调方式。）
2. **启动后端必须带端口参数**：`java -jar target/springBootTest-0.0.1-SNAPSHOT.jar --server.port=8081`
   ⚠️ 绝不能省略：环境变量 SERVER__PORT 可能被 Spring 宽松绑定读走，导致端口错乱。
3. **数据库自检**：`"C:/Program Files/MySQL/MySQL Server 8.0/bin/mysql.exe" -uroot -p123456 -e "USE springboottest;"` 失败则导入：
   `mysql.exe -uroot -p123456 --default-character-set=utf8mb4 < springboottest.sql`
4. **前端**：`cd frontend-5173 && npm ci`（.npmrc 已配 npmmirror）→ `npm run dev -- --strictPort` → http://localhost:5173
5. **验证**：`curl --noproxy localhost http://localhost:5173/` 返回 200；后端 `curl --noproxy 127.0.0.1 http://127.0.0.1:8081/api/home/summary` 返回 401（未登录）即后端正常。

## 三、已知坑（踩过，勿重蹈）

- **纯 Vue 项目**：前端唯一入口是 `http://localhost:5173`，无任何单文件 .html。`/onepiece` 是 Vue 内部路由（航海王全史页），`/admin` 是后台。
- **后端 8081 是纯 API**：不返回 html 页面，访问 `http://localhost:8081/Luffy.html` 会 404。
- **curl 502 假象**：本机有系统代理，直接 curl localhost 会走代理返回 502/000，必须加 `--noproxy localhost`。
- **前端整站白屏排查顺序**：HomePage.vue / App.vue 若 import 了缺失的组件（如 OnePieceShow.vue），Vite 会编译报错整站白屏。先 `curl http://localhost:5173/src/components/XXX.vue` 看是否 200，缺失则补建。
- **用户名长度**：后端按 Java String.length 校验 ≥3，两个汉字（如"索隆"）会被拒。
- **MySQL 保留字**：表名用 `sys_user` 不是 `user`。
- **taskkill 在 Git Bash**：用 `taskkill /F /PID xxx`（单斜杠），`//F` 反而报错。
- **改 bat 必须保持 GBK 编码**：先写 UTF-8 再 `iconv -f UTF-8 -t GBK` 或 Python `encode('gbk')` 转换。
- **重新打包前先停 8081 后端**：进程锁住 target jar，Maven repackage 会报 "Unable to rename"。
- **改后端代码后必须重启 java -jar**：跑的是打包产物，改源码不重启等于没改。
- **curl 测中文参数**：用 `-G --data-urlencode "keyword=xx"`，裸中文进 URL 会被 Tomcat 拒。
- **agent-browser 在本机的坑**：① 会话易丢，验证必须把 open→操作→eval 串在同一条 bash 命令；② 截图全白（GPU 合成问题），用 `eval "document.body.innerText"` 读 DOM 文本；③ Vue 异步更新，点击后要 sleep 1 再 eval。

## 四、架构速查

- 后端：backend-8081/，Spring Boot 3.4.5 + MyBatis-Plus 3.5.9，profile=dev（端口 8081，MySQL root/123456，库 springboottest）。Java 21（Zulu）。
- 用户表：sys_user（接口：POST /api/user/register | /login | /reset；GET /api/user/profile；POST /api/user/change-password | /logout，后三者需 X-Token）。
- 首页：表 home_route（航线）、home_wanted（悬赏令）、home_crew（名册）、home_shop（店铺）、home_story（篇章）。接口 GET /api/home/summary、GET /api/home/search?keyword=、GET /api/home/crews|routes|wanteds|shops|stories，均需 X-Token。
- 后台：表 admin_user，接口 /api/admin/login|logout|stats|crews|routes|wanteds|shops|stories（增删改查）。
- Vue 前端：frontend-5173/，Vite 代理 /api → 8081。组件 src/components/（OnePieceShow.vue=航海王全史，HomePage.vue=首页，LoginForm/RegisterForm/ResetForm=登录注册重置，AdminLogin/AdminPanel=后台，CrewPanel/RoutePanel/WantedPanel/ShopPanel/StoryPanel=五个内容面板，SeaScene/BrandPanel/SuccessModal/ConfettiLayer=装饰层）。API 封装 src/api/user.js、home.js、admin.js。
- 演示账号：路飞 / 123456（luffy@onepiece.com）。

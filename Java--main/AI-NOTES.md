# AI-NOTES —— 项目启动手册（AI 专用备忘）

> 本文件写给 AI 助手自己看：下次会话遇到"启动项目 / 连不上后端"时，**直接按本手册执行，不要重新排查**。
> 电脑每次重置后 node_modules、target 会被删除，但 .m2、MySQL、项目源码都保留。

## 目录结构（2026-11-02 纯 Vue 化后）

```
Java--main/
├── backend-8081/        后端 Spring Boot 工程（纯 API，无静态页面）
├── frontend-5173/       前端 Vue3 + Vite 工程（纯 Vue，入口仅 index.html）
├── springboottest_backup_20261102.sql  完整数据库快照（7 表结构 + 全数据，唯一权威正本）
├── AI-NOTES.md          本文件
├── start-all.bat / stop-all.bat   一键启停入口（调用 start-all.ps1 / stop-all.ps1）
├── start-all.ps1 / stop-all.ps1   核心逻辑（PowerShell，UTF-8 BOM 编码，含健康检查）
├── start-backend.bat / start-frontend.bat   单独启停（旧 bat，仍可用）
```

> 注意：单文件版 Luffy.html、OnePiece.html 已全部转换为 Vue 组件并删除，项目是纯 Vue。
> 后端已删除废弃 UserController.java（Thymeleaf）和 static/templates 里的旧 html，纯 API 服务。

## 一、最快启动方式（优先推荐）

让用户双击 `D:\workSpace\Java-\Java--main\` 下的脚本（GBK 编码，相对路径，重置后可用）：

| 脚本 | 作用 |
|------|------|
| `start-all.bat` | 一键入口，调用 start-all.ps1：数据库自检+初始化 → 后台启动后端(8081，健康检查) → 后台启动前端(5173，strictPort) → 开浏览器 |
| `stop-all.bat` | 一键停止入口，调用 stop-all.ps1：杀 8081/5173/5174 进程 |
| `start-backend.bat` | 只启动后端（缺 target 自动 mvnw 编译） |
| `start-frontend.bat` | 只启动前端（缺 node_modules 自动 npm ci） |

> 关键改进（2026-11-02）：start-all 改用 PowerShell（UTF-8 BOM），用 Start-Process 后台启动 + 轮询端口健康检查，替代旧的 `start /min cmd /c` + 固定 timeout；前端 vite.config.js 加 `strictPort: true`，避免 5173 被占时静默顺延到 5174 导致打开错地址。
> 注意：.ps1 文件必须是 UTF-8 BOM 编码，否则 PowerShell 5.1 按 GBK 读中文注释会乱码。

## 二、如果 AI 要自己动手（无脚本场景），按此顺序执行

1. **构建后端**：`mvnw` 在 Git Bash 下有 bug（classworlds Launcher 找不到），**不要用 mvnw**。用 java 直调：
   ```
   cd D:/workSpace/Java-/Java--main/backend-8081
   D=C:/Users/Administrator/.m2/wrapper/dists/apache-maven-3.9.16-bin/5grr65jo27hi51sujmtcldfovl/apache-maven-3.9.16
   java -cp "$D/boot/plexus-classworlds-2.11.0.jar" -Dclassworlds.conf="$D/bin/m2.conf" \
     -Dmaven.home="$D" -Dmaven.multiModuleProjectDirectory="D:/workSpace/Java-/Java--main/backend-8081" \
     org.codehaus.plexus.classworlds.launcher.Launcher -s maven-settings.xml -DskipTests package
   ```
   （若 $D 不存在，mvnw.cmd 会从阿里云自动下载发行版；maven-wrapper.properties 已改为阿里云源）
2. **启动后端必须带端口参数**：`java -jar target/springBootTest-0.0.1-SNAPSHOT.jar --server.port=8081`
   ⚠️ 绝不能省略：环境变量 SERVER__PORT=49469 会被 Spring 宽松绑定读走，且 49469 被系统占用，服务必挂。
3. **数据库自检**：`"C:/Program Files/MySQL/MySQL Server 8.0/bin/mysql.exe" -uroot -p123456 -e "USE springboottest;"` 失败则执行：
   `mysql.exe -uroot -p123456 --default-character-set=utf8mb4 < springboottest_backup_20261102.sql`（完整快照，一键重建 7 表+数据）
4. **前端**：`cd frontend-5173 && npm ci`（.npmrc 已配 npmmirror）→ `npm run dev` → http://localhost:5173
5. **验证**：`curl --noproxy localhost http://localhost:5173/` 应返回 200（加 --noproxy，本机有系统代理会干扰 curl）。后端 API 验证：`curl --noproxy 127.0.0.1 http://127.0.0.1:8081/api/home/summary` 返回 401（未登录）即后端正常。

## 三、已知坑（踩过，勿重蹈）

- **纯 Vue 项目**：前端唯一入口是 `http://localhost:5173`（Vue 的 index.html），无任何单文件 .html。`/onepiece` 是 Vue 内部路由（航海王全史页），`/admin` 是后台。
- **后端 8081 是纯 API**：不再返回任何 html 页面，访问 `http://localhost:8081/Luffy.html` 会 404（旧静态文件已删除）。
- **curl 502 假象**：本机有系统代理，直接 curl localhost 会走代理返回 502/000，必须加 `--noproxy localhost`。
- **用户名长度**：后端按 Java String.length 校验 ≥3，两个汉字（如"索隆"）会被拒。
- **MySQL 保留字**：表名用 `sys_user` 不是 `user`。
- **luffy_register.sql 已删除**（sys_user 表已含在完整快照 springboottest_backup_20261102.sql 里，无需单独脚本）。
- **taskkill 在 Git Bash**：用 `taskkill /F /PID xxx`（单斜杠），`//F` 反而报错。
- **改 bat 必须保持 GBK 编码**：先写 UTF-8 再 `iconv -f UTF-8 -t GBK` 转换，直接编辑 GBK 文件会写坏中文。
- **重新打包前先停 8081 后端**：进程锁住 target jar，Maven repackage 会报 "Unable to rename"。
- **改后端代码后必须重启 java -jar**：跑的是打包产物，改源码不重启等于没改。
- **curl 测中文参数**：用 `-G --data-urlencode "keyword=xx"`，裸中文进 URL 会被 Tomcat 拒（400 Invalid character）。
- **前端缺 src/api/home.js 会整站白屏**：HomePage.vue import 了它，缺失时 Vite 直接报错、页面渲染为空。排查顺序：先看 `curl http://localhost:5173/src/components/HomePage.vue` 是否 200。
- **agent-browser 在本机的坑**（2026-10-29 实测）：① 会话在命令之间易丢，页面变 about:blank 且 localStorage 报 SecurityError，验证必须把 open→操作→eval 串在同一条 bash 命令里；② 截图全白（Chrome 156 GPU 合成问题），别靠截图判断页面，改用 `agent-browser eval "document.body.innerText"` 读 DOM 文本；③ `snapshot -i` 返回空，直接用 CSS 选择器（#lAccount / #lPwd / #lBtn / .search input / .search-btn / .result-item.clickable）；④ Vue 异步更新，点击后要 sleep 1 再 eval，否则会误判弹窗没关。

## 四、架构速查

- 后端：backend-8081/，Spring Boot 3.4.5 + MyBatis-Plus，profile=dev（application-dev.properties，端口 8081，MySQL root/123456，库 springboottest）。
- 用户表：sys_user（接口：POST /api/user/register | /login | /reset；GET /api/user/profile；POST /api/user/change-password | /logout，后三者需 X-Token）。
- 首页（2026-10-26 新增，2026-10-29 补齐后端+详情弹窗，2026-11-02 补字段+扩数据）：表 home_route（航线 13 条）、home_wanted（悬赏令 21 条）、home_crew（名册 31 条）、home_shop（店铺 12 条）、home_story（篇章 12 条）。完整表结构+数据以 springboottest_backup_20261102.sql 为唯一权威正本（含全部字段和数据，含新增7角色）。接口 GET /api/home/summary、GET /api/home/search?keyword=、GET /api/home/crews|routes|wanteds|shops|stories，均需 X-Token。
- Vue 前端：frontend-5173/，Vite 代理 /api → 8081（vite.config.js 已配好）；组件 src/components/（OnePieceShow.vue=航海王全史 /onepiece 无需登录，HomePage.vue=首页，LoginForm/RegisterForm/ResetForm=登录注册重置）。API 封装 src/api/user.js、src/api/home.js、src/api/admin.js。
- 演示账号：路飞 / 123456（luffy@onepiece.com）。

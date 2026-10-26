# AI-NOTES —— 项目启动手册（AI 专用备忘）

> 本文件写给 AI 助手自己看：下次会话遇到"启动项目 / 连不上后端"时，**直接按本手册执行，不要重新排查**。
> 电脑每次重置后 node_modules、target 会被删除，但 .m2、MySQL、项目源码都保留。

## 目录结构（2026-10-23 重整后）

```
Java--main/
├── backend-8081/        后端 Spring Boot 工程（原 springBootTest）
├── frontend-5173/       前端 Vue3 + Vite 工程（原 luffy-vue，内含单文件版 Luffy.html）
├── luffy_register.sql   数据库初始化脚本
├── AI-NOTES.md          本文件
└── start-*.bat / stop-all.bat   启停脚本（GBK 编码，%~dp0 相对路径）
```

## 一、最快启动方式（优先推荐）

让用户双击 `D:\workSpace\Java-\Java--main\` 下的脚本（GBK 编码，相对路径，重置后可用）：

| 脚本 | 作用 |
|------|------|
| `start-all.bat` | 一键：数据库自检+初始化 → 编译并启动后端(8081) → 装依赖并启动前端(5173) → 开浏览器 |
| `start-backend.bat` | 只启动后端（缺 target 自动 mvnw 编译） |
| `start-frontend.bat` | 只启动前端（缺 node_modules 自动 npm ci） |
| `start-luffy.bat` | 只开单文件版网页（frontend-5173\Luffy.html）+ 确保后端在跑 |
| `stop-all.bat` | 杀掉 8081 / 5173 进程 |

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
   `mysql.exe -uroot -p123456 --default-character-set=utf8mb4 < luffy_register.sql`（项目顶层有一份）
4. **前端**：`cd frontend-5173 && npm ci`（.npmrc 已配 npmmirror）→ `npm run dev` → http://localhost:5173
5. **验证**：`curl --noproxy localhost http://localhost:8081/Luffy.html` 应返回 200（加 --noproxy，本机有系统代理会干扰 curl）。

## 三、已知坑（踩过，勿重蹈）

- **CORS**：双击 Luffy.html（file://）时 Origin 为 null。backend-8081/src/main/java/.../WebConfig.java 的 allowedOriginPatterns 必须包含 `"null"`，删了双击打开就废。
- **curl 502 假象**：本机有系统代理，直接 curl localhost 会走代理返回 502/000，必须加 `--noproxy localhost`。
- **用户名长度**：后端按 Java String.length 校验 ≥3，两个汉字（如"索隆"）会被拒。
- **MySQL 保留字**：表名用 `sys_user` 不是 `user`。
- **luffy_register.sql 含 DROP TABLE**：重跑清空所有注册数据。
- **taskkill 在 Git Bash**：用 `taskkill /F /PID xxx`（单斜杠），`//F` 反而报错。
- **改 bat 必须保持 GBK 编码**：先写 UTF-8 再 `iconv -f UTF-8 -t GBK` 转换，直接编辑 GBK 文件会写坏中文。
- **重新打包前先停 8081 后端**：进程锁住 target jar，Maven repackage 会报 "Unable to rename"。
- **改后端代码后必须重启 java -jar**：跑的是打包产物，改源码不重启等于没改。
- **curl 测中文参数**：用 `-G --data-urlencode "keyword=xx"`，裸中文进 URL 会被 Tomcat 拒（400 Invalid character）。

## 四、架构速查

- 后端：backend-8081/，Spring Boot 3.4.5 + MyBatis-Plus，profile=dev（application-dev.properties，端口 8081，MySQL root/123456，库 springboottest）。
- 用户表：sys_user（接口：POST /api/user/register | /login | /reset；GET /api/user/profile；POST /api/user/change-password | /logout，后三者需 X-Token）。
- 首页（2026-10-26 新增）：表 home_route（航线）、home_wanted（悬赏令），建表脚本 home_init.sql（顶层正本，可重复执行不清数据）；接口 GET /api/home/summary（首页统计+榜单）、GET /api/home/search?keyword=（航线/悬赏/船员三路搜索），均需 X-Token（WebConfig 保护 /api/home/**）。
- 单文件页：frontend-5173/Luffy.html（同源访问 /api；file:// 时直连 8081）。另有内置副本 backend-8081/src/main/resources/static/Luffy.html。
- Vue 前端：frontend-5173/，Vite 代理 /api → 8081（vite.config.js 已配好）；API 封装 src/api/user.js（request 已支持完整 /api 路径复用）与 src/api/home.js；首页组件 src/components/HomePage.vue（含统计、真实榜单卡片、搜索结果面板）。
- 演示账号：路飞 / 123456（luffy@onepiece.com）。
- 历史遗留副本（LoginInterceptor.java、user.js、_target_backup、sql/、backend 根下 luffy_register.sql）已于 2026-10-23 清理；SQL 正本在 Java--main 顶层（luffy_register.sql 管 sys_user，home_init.sql 管首页两表）。luffy-vue/ 是无登录功能的旧副本，勿在其上开发。log/ 为运行日志，勿删。

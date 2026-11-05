import asyncio
from playwright.async_api import async_playwright

CHROME = r"C:/Users/Administrator/.agent-browser/browsers/chrome-157.0.8103.38/chrome.exe"

async def main():
    async with async_playwright() as p:
        b = await p.chromium.launch(executable_path=CHROME, headless=True,
            args=["--no-sandbox","--disable-gpu","--disable-dev-shm-usage",
                  "--disable-blink-features=AutomationControlled"])
        pg = await b.new_page()
        await pg.goto("http://localhost:5173", wait_until="networkidle", timeout=30000)
        await pg.wait_for_timeout(2000)
        # 用 id 登录
        await pg.fill("#lAccount", "路飞")
        await pg.fill("#lPwd", "123456")
        await pg.click("#lBtn")
        print("已提交登录")
        await pg.wait_for_timeout(4000)
        # 尝试进入篇章故事（如有导航标签）
        try:
            nav = pg.get_by_text("篇章故事", exact=False)
            if await nav.count():
                await nav.first.click()
                print("已点击『篇章故事』导航")
                await pg.wait_for_timeout(2000)
        except Exception as e:
            print("导航点击跳过:", e)
        # 找视频按钮
        btns = await pg.evaluate("""()=>Array.from(document.querySelectorAll('button')).map(b=>b.textContent.trim()).filter(t=>t.length>0)""")
        print("主页可见按钮样例:", btns[:15])
        loc = pg.locator('button', has_text='解说')
        n = await loc.count()
        print(f"含『解说』的按钮数量: {n}")
        if n:
            await loc.first.click(timeout=6000)
            print("已点击视频按钮")
        await pg.wait_for_timeout(4000)
        src = await pg.evaluate("""()=>{const f=document.querySelector('iframe[src*=\"player.bilibili.com\"]'); return f?f.src:null;}""")
        if src:
            print("✅ IFRAME 加载成功 ->", src)
        else:
            print("❌ 未检测到 player.bilibili.com 的 iframe")
        await b.close()

asyncio.run(main())

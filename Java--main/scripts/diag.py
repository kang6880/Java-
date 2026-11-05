import asyncio
from urllib.parse import quote
from playwright.async_api import async_playwright

CHROME = r"C:/Users/Administrator/.agent-browser/browsers/chrome-157.0.8103.38/chrome.exe"
UA = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36")

async def main():
    async with async_playwright() as p:
        b = await p.chromium.launch(executable_path=CHROME, headless=True,
            args=["--no-sandbox","--disable-gpu","--disable-dev-shm-usage",
                  "--disable-blink-features=AutomationControlled"])
        ctx = await b.new_context(user_agent=UA, locale="zh-CN")
        pg = await ctx.new_page()
        url = "https://search.bilibili.com/video?keyword=" + quote("海贼王 东海篇 剧情解说")
        await pg.goto(url, wait_until="domcontentloaded", timeout=30000)
        await pg.wait_for_timeout(6000)
        info = await pg.evaluate("""() => {
            const links = Array.from(document.querySelectorAll('a[href*="/video/"]')).slice(0,16);
            return links.map(a=>({cls:a.className, title:a.getAttribute('title'), text:(a.textContent||'').replace(/\\s+/g,' ').slice(0,25)}));
        }""")
        for i,t in enumerate(info):
            print(i, t)
        # 找包含"海贼王"文本的 a 的 class
        titles = await pg.evaluate("""() => {
            const all = Array.from(document.querySelectorAll('a[href*=\"/video/\"]'));
            return all.filter(a=>(a.textContent||'').includes('海贼王')).slice(0,5).map(a=>({cls:a.className, text:(a.textContent||'').replace(/\\s+/g,' ').slice(0,40)}));
        }""")
        print("--- 含'海贼王'文本的链接 ---")
        for t in titles:
            print(t)
        await b.close()

asyncio.run(main())

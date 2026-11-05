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
        await pg.wait_for_timeout(3000)
        txt = await pg.evaluate("()=>document.body.innerText.slice(0,1200)")
        print("=== BODY TEXT ===\n", txt)
        keys = await pg.evaluate("""()=>Array.from(document.querySelectorAll('button,a,input,[class*=btn]')).map(e=>({t:e.tagName, txt:(e.textContent||e.value||'').trim().slice(0,24), cls:(''+e.className).slice(0,40)})).filter(e=>/登录|注册|篇章|解说|故事|视频|按钮/.test(e.txt))""")
        print("=== KEY ELEMENTS ===")
        for k in keys[:25]:
            print(k)
        await b.close()

asyncio.run(main())

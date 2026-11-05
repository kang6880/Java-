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
        els = await pg.evaluate("""()=>Array.from(document.querySelectorAll('input,textarea,button')).map(e=>({t:e.tagName, type:e.type||'', ph:e.placeholder||'', txt:(e.textContent||'').trim().slice(0,20), cls:(''+e.className).slice(0,50), id:e.id||''}))""")
        for e in els:
            print(e)
        await b.close()

asyncio.run(main())

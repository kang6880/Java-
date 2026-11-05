import asyncio
from playwright.async_api import async_playwright

CHROME = r"C:/Users/Administrator/.agent-browser/browsers/chrome-157.0.8103.38/chrome.exe"
UA = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36")

# id -> 待验证 BV（含阿拉巴斯坦 id=2 既有值，确认其正确性）
bvs = {
    1:  "BV1Q541137VL",   # 东海篇 剧情解说01
    2:  "BV1NU4y1b7eZ",   # 阿拉巴斯坦篇 既有值(补全计划02) 待确认
    3:  "BV12S4y1C7wu",   # 空岛篇 3小时一口气看完
    4:  "BV1bB4y1u7gU",   # 司法岛篇 剧情解说05
    5:  "BV1aWnz6QEvj",   # 恐怖三桅帆船篇 一口气看完
    7:  "BV1GxZpYqEoY",   # 鱼人岛篇 新鱼人岛篇全集
    8:  "BV1254y1G7Kz",   # 德雷斯罗萨篇 剧情解说13
    9:  "BV1z5411T7a7",   # 佐乌篇 剧情解说15
    10: "BV1pJ41137ez",   # 蛋糕岛篇 大妈篇二十分钟看完
}

async def main():
    async with async_playwright() as p:
        b = await p.chromium.launch(executable_path=CHROME, headless=True,
            args=["--no-sandbox","--disable-gpu","--disable-dev-shm-usage",
                  "--disable-blink-features=AutomationControlled"])
        ctx = await b.new_context(user_agent=UA, locale="zh-CN")
        pg = await ctx.new_page()
        for cid, bv in bvs.items():
            try:
                await pg.goto(f"https://www.bilibili.com/video/{bv}",
                              wait_until="domcontentloaded", timeout=20000)
                await pg.wait_for_timeout(3000)
                title = await pg.title()
                ok = ("不存在" not in title) and ("已失效" not in title) and ("已下架" not in title)
                print(f"id={cid} {bv} {'OK' if ok else 'INVALID'} | {title[:40]}")
            except Exception as e:
                print(f"id={cid} {bv} ERR {e}")
        await b.close()

asyncio.run(main())

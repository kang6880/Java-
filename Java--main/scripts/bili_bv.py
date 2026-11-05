import asyncio, json
from urllib.parse import quote
from playwright.async_api import async_playwright

CHROME = r"C:/Users/Administrator/.agent-browser/browsers/chrome-157.0.8103.38/chrome.exe"

# (数据库 id, 篇章名, 搜索关键词)
chapters = [
    (1,  "东海篇",         "海贼王 东海篇 剧情解说"),
    (3,  "空岛篇",         "海贼王 空岛篇 剧情解说"),
    (4,  "司法岛篇",       "海贼王 司法岛篇 剧情解说"),
    (5,  "恐怖三桅帆船篇", "海贼王 恐怖三桅帆船篇 剧情解说"),
    (7,  "鱼人岛篇",       "海贼王 鱼人岛篇 剧情解说"),
    (8,  "德雷斯罗萨篇",   "海贼王 德雷斯罗萨篇 剧情解说"),
    (9,  "佐乌篇",         "海贼王 佐乌篇 剧情解说"),
    (10, "蛋糕岛篇",       "海贼王 蛋糕岛篇 剧情解说"),
]

UA = ("Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
      "(KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36")

EXTRACT_JS = """() => {
    const res = [];
    const seen = new Set();
    const links = Array.from(document.querySelectorAll('a[href*="/video/"]'));
    for (const a of links) {
        const m = (a.href || '').match(/BV[0-9A-Za-z]+/);
        if (!m) continue;
        const bv = m[0];
        const text = (a.textContent || '').replace(/\\s+/g, ' ').trim();
        if (text.includes('稍后再看')) continue;   // 卡片外层噪音链接
        if (seen.has(bv)) continue;
        seen.add(bv);
        res.push({bv, title: text});
    }
    return res;
}"""

def pick_best(data, name):
    kw = name.replace('篇', '')
    explain_kw = [d for d in data if '解说' in d['title'] and kw in d['title']]
    explain    = [d for d in data if '解说' in d['title']]
    kw_only    = [d for d in data if kw in d['title']]
    pick = (explain_kw + explain + kw_only + data)[:1]
    return pick[0] if pick else None

async def fetch_cands(page, kw):
    url = "https://search.bilibili.com/video?keyword=" + quote(kw)
    try:
        await page.goto(url, wait_until="domcontentloaded", timeout=30000)
    except Exception as e:
        print("  goto 警告:", e)
    await page.wait_for_timeout(5000)
    # 验证码检测
    captcha = await page.evaluate("() => !!(document.querySelector('#captcha, .geetest_panel, [class*=captcha]'))")
    data = await page.evaluate(EXTRACT_JS)
    return captcha, data

async def main():
    all_out = {}
    async with async_playwright() as p:
        browser = await p.chromium.launch(
            executable_path=CHROME,
            headless=True,
            args=["--no-sandbox", "--disable-gpu", "--disable-dev-shm-usage",
                  "--disable-blink-features=AutomationControlled"],
        )
        context = await browser.new_context(user_agent=UA, locale="zh-CN")
        page = await context.new_page()
        try:
            await page.goto("https://www.bilibili.com", wait_until="domcontentloaded", timeout=20000)
            await page.wait_for_timeout(2000)
        except Exception as e:
            print("首页访问警告:", e)
        for cid, name, kw in chapters:
            try:
                captcha, data = await fetch_cands(page, kw)
                best = pick_best(data, name)
                all_out[str(cid)] = {"name": name, "captcha": captcha,
                                     "best": best, "cands": data[:10]}
                print(f"\n=== {name} (captcha={captcha}) 候选{len(data)}个 ===")
                for d in data[:10]:
                    mark = "  <<< 选定" if best and d['bv'] == best['bv'] else ""
                    print(f"  {d['bv']}  {d['title'][:48]}{mark}")
            except Exception as e:
                all_out[str(cid)] = {"name": name, "error": str(e)}
                print(f"[{name}] ERROR {e}")
        await browser.close()
    with open("scripts/bili_bv_result.json", "w", encoding="utf-8") as f:
        json.dump(all_out, f, ensure_ascii=False, indent=2)
    print("\nALL DONE -> scripts/bili_bv_result.json")

asyncio.run(main())

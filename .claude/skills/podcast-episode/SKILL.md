---
name: podcast-episode
description: >
  生成或修改單集 Episode XML 時套用。提供 SSML 標準結構模板、關鍵字 Pattern 選用規則、
  格式防範規則與完整生成步驟。
---

# podcast-episode Skill

## 1. Episode XML 標準結構（模板）

```xml
<speak version="1.0"
       xmlns="http://www.w3.org/2001/10/synthesis"
       xmlns:mstts="http://www.w3.org/2001/mstts"
       xml:lang="zh-TW">

  <!-- ── 1. 開場對話（cheerful，2–4 輪） ── -->
  <voice name="zh-TW-HsiaoChenNeural">
    <mstts:express-as style="cheerful">
      <prosody rate="+10%">
        [曉臻開場，介紹本集主題，1–2 句]
      </prosody>
    </mstts:express-as>
  </voice>
  <voice name="en-US-PhoebeMultilingualNeural">
    <mstts:express-as style="cheerful">
      <prosody rate="+10%">
        <lang xml:lang="zh-TW">
          [Phoebe 中文輕鬆回應，1–2 句]
        </lang>
      </prosody>
    </mstts:express-as>
  </voice>
  <!-- 可視需要追加 1–2 輪對話 -->

  <!-- ── 2. 分組過場（cheerful，可選，段落之間才加） ── -->
  <voice name="zh-TW-HsiaoChenNeural">
    <mstts:express-as style="cheerful">
      <prosody rate="+10%">
        [引入下一組關鍵字主題的過場白，1–2 句]
      </prosody>
    </mstts:express-as>
  </voice>
  <voice name="en-US-PhoebeMultilingualNeural">
    <mstts:express-as style="cheerful">
      <prosody rate="+10%">
        <lang xml:lang="zh-TW">
          [Phoebe 補充或延伸，1–2 句]
        </lang>
      </prosody>
    </mstts:express-as>
  </voice>

  <!-- ── 3. 關鍵字區塊（裸文字，重複 N 次） ── -->
  <!-- 規則：絕對不加 express-as 或 prosody；依詞彙類型選擇下列三種 Pattern 之一 -->

  <!-- Pattern A：有中文名稱的詞彙（如「虛擬私有雲」「負載平衡」） -->
  <voice name="zh-TW-HsiaoChenNeural">
    [中文詞彙名稱]
  </voice>
  <voice name="en-US-PhoebeMultilingualNeural">
    [英文詞彙]...
    [英文例句 1]
    [英文例句 2]
  </voice>
  <voice name="zh-TW-HsiaoChenNeural">
    [中文翻譯（對應例句，逐句）]
  </voice>

  <!-- Pattern B：無固定中文名稱、直接以英文通用的詞彙（如 Azure、Docker、Android） -->
  <!-- Phoebe 不重複念詞彙，直接說例句 -->
  <voice name="zh-TW-HsiaoChenNeural">
    [英文詞彙]
  </voice>
  <voice name="en-US-PhoebeMultilingualNeural">
    [英文例句 1]
    [英文例句 2]
  </voice>
  <voice name="zh-TW-HsiaoChenNeural">
    [中文翻譯（對應例句，逐句）]
  </voice>

  <!-- Pattern C：縮寫詞（Abbreviation），Phoebe 先念縮寫、再說全稱；曉臻念中文全稱或縮寫（依是否有中文名稱決定） -->
  <voice name="zh-TW-HsiaoChenNeural">
    [中文全稱] 或 [縮寫]（無中文名稱時直接念縮寫）
  </voice>
  <voice name="en-US-PhoebeMultilingualNeural">
    [縮寫]...
    [縮寫] stands for [英文全稱].
    [英文例句]
  </voice>
  <voice name="zh-TW-HsiaoChenNeural">
    [縮寫] 是 [英文全稱] 的縮寫。
    [例句中文翻譯]
  </voice>

  <!-- ── 4. Mock Discussion（cheerful，3–4 輪，放在 Outro 前） ── -->
  <!-- 規則：曉臻用中文開啟職場情境，Phoebe 用英文自然回應並帶入本集關鍵字（≥3 個），對話共 30–60 秒 -->
  <voice name="zh-TW-HsiaoChenNeural">
    <mstts:express-as style="cheerful">
      <prosody rate="+10%">
        [曉臻：用中文描述職場情境問題]
      </prosody>
    </mstts:express-as>
  </voice>
  <voice name="en-US-PhoebeMultilingualNeural">
    <mstts:express-as style="cheerful">
      <prosody rate="+10%">
        [Phoebe：英文回應，帶入關鍵字]
      </prosody>
    </mstts:express-as>
  </voice>
  <!-- 繼續 1–2 輪追問與收尾 -->

  <!-- ── 5. Outro（cheerful，動態生成） ── -->
  <!-- 生成規則：
    曉臻：① 本集主題的核心帶走概念（1 句，用本集關鍵字，不說集數編號）
           ② 報名（「我是曉臻」或「我是主持人曉臻」，隨集變換）
           ③ 道別語（從以下取樣或類似變體，不重複固定用詞）：
              「下次見！」「我們下次見。」「感謝大家的陪伴。」「拜拜！」
           ④ 若本集為系列的第一集（如 Git Basics → Git Advanced），
              可加一句方向性暗示（如「Git 還有更多進階功夫等你」），
              禁止明說下集集數或下集標題。
              若非系列或最後一集，省略此句。
    Phoebe：英文道別，從以下取樣或類似變體（不固定，每集不同）：
              "Catch you later!", "Level up with us next time.",
              "See you next time!", "Keep building!", "Stay curious!" -->
  <voice name="zh-TW-HsiaoChenNeural">
    <mstts:express-as style="cheerful">
      <prosody rate="+10%">
        [依上述規則動態生成]
      </prosody>
    </mstts:express-as>
  </voice>
  <voice name="en-US-PhoebeMultilingualNeural">
    <mstts:express-as style="cheerful">
      <prosody rate="+10%">
        [依上述規則動態生成]
      </prosody>
    </mstts:express-as>
  </voice>

</speak>
```

---

## 2. 關鍵字 Pattern 選用規則

| 詞彙類型 | 判斷標準 | 套用 Pattern |
| --- | --- | --- |
| 有固定中文名稱 | 中文技術圈普遍使用（如「負載平衡」「容器」「函式庫」） | Pattern A |
| 無固定中文名稱 | 品牌名、工具名、英文原文通用（如 Docker、Azure、Redis） | Pattern B |
| 縮寫詞，有中文全稱 | 如 IaaS → 基礎設施即服務、VPC → 虛擬私有雲 | Pattern C（曉臻念中文全稱） |
| 縮寫詞，無中文全稱 | 如 API、DNS、SDK、CI/CD | Pattern C（曉臻直接念縮寫） |

---

## 3. 常見格式錯誤的防範規則

| 錯誤類型 | 正確做法 |
| --- | --- |
| 關鍵字區塊誤加 `cheerful` / `prosody` | 關鍵字三段（曉臻詞彙、Phoebe 例句、曉臻翻譯）一律裸文字，不加任何 tag |
| Mock Discussion 重複插入 | 整份 XML 只允許一個 Mock Discussion 區塊，位於最後一組關鍵字之後、Outro 之前 |
| Phoebe 在關鍵字區塊說中文 | 只有開場、過場、Mock Discussion、Outro 才允許 Phoebe 說中文（用 `<lang xml:lang="zh-TW">` 包覆） |
| Phoebe 在 Mock Discussion 說中文未包 lang | Phoebe 的中文內容必須包 `<lang xml:lang="zh-TW">` |
| `<speak>` 內層出現重複 xmlns 宣告 | xmlns 宣告只出現在根元素 `<speak>`，內層 voice 區塊不重複 |
| Outro 說出集數編號 | 禁止出現「第 N 集」「這是第 N 集」等文字 |
| Outro 透露下集標題 | 禁止出現「下一集我們將討論...」，系列銜接只能說方向不說題目 |

---

## 4. 執行步驟

1. 讀取目前集數的 XML（若已存在）或使用者提供的主題與關鍵字清單。
2. **規劃分組大綱**：先列出預計的 group 清單與每個 group 的主題標籤（即過場對話要說的重點），再分配詞彙。分組原則：
   - 依功能領域或使用情境劃分（不依字母、不依中英文混排）。
   - 組內詞彙按**概念 → 具體工具 → 操作/注意事項**排列。
   - 每組 3–6 個詞；若同一主題詞彙較多，拆成兩組並各寫一段過場，不強塞。
3. 依照 §1 模板生成完整 XML，依 §2 判斷每個詞彙的 Pattern，套用對應結構。
4. 生成 Mock Discussion，帶入本集至少 3 個關鍵字。
5. 依 §1 Outro 規則動態生成告別詞，不固定用語，不說集數，系列性暗示僅說方向。
6. 套用 §3 的格式防範規則，自我檢查後輸出。

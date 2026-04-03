---
name: podcast-vocab
description: >
  補充或擴充既有 Episode XML 的詞彙時套用。提供分組識別機制、詞彙缺口評估與分組擴充流程，
  確保新詞融入現有結構且例句完整。
---

# podcast-vocab Skill

## 1. 分組識別機制

每個 cheerful 過場對話的文字即為該 group 的「主題標籤」，例如：

> 「運算資源是雲端轉型的核心，除了傳統虛擬機，GPU 也是 AI 時代的算力關鍵。」
> → 對應 group：GPU Instance、Serverless、Inference Endpoint、Cold Start

組內詞彙有隱性順序：**概念 → 具體工具 → 操作/注意事項**。新增詞彙時必須判斷在 group 內的插入位置，不一定放最後。

---

## 2. 執行步驟

1. **建立分組清單**：讀取 XML，依 cheerful 過場位置切分出所有 group，每個 group 記錄：
   - 過場文字（主題標籤）。
   - 目前詞彙清單（含順序）。
2. **評估缺口**：對照該集主題的主流技術詞彙（參考近期技術趨勢），找出遺漏或待更新詞彙。
3. **分配新詞至現有 group**：
   - 以過場文字（主題標籤）為主要比對依據，找語意最接近的 group。
   - 在 group 內，依「概念 → 工具 → 操作」順序決定插入位置。
4. **分組過長時拆分**：若某 group 加入新詞後超過 6 個詞，且能明確劃分成兩個子主題，才拆分為兩個 group 並各補一段新的過場對話。無明確子主題時維持原 group，上限放寬至 8 個詞。
5. **找不到適合 group 時新建**：若新詞與所有現有主題標籤都不吻合，在邏輯位置新建 group，並撰寫對應的過場對話。
6. **例句補齊**：若既有詞彙只有一個例句，補第二個例句。
7. 輸出完整修改後的 XML。

---

## 3. 詞彙選取原則

- 優先補充近期技術社群高頻出現的術語（如 LLM、RAG、MCP、edge computing、AI agent 等），確保內容反映現代開發生態。
- 每集新增詞彙數以 3–8 個為宜；若差距過大，分多次擴充，每次先處理最核心的缺口。
- 新詞的例句需符合職場使用情境（Code Review、設計評審、日常溝通），不寫教科書式例句。

---

## 4. 批次清整範圍

全部 30 集，按以下 5 批執行（每批完成後提交 commit）：

| 批次 | 集數 | 主題範圍 |
| --- | --- | --- |
| Batch A | Ep01–06 | CS Basics, Algorithms, Linux, Git (x2), Database SQL |
| Batch B | Ep07–12 | Database NoSQL, Data Engineering, Backend .NET (x2), Web HTTP |
| Batch C | Ep13–18 | Web Frontend, UI/UX, Mobile, Data Science, DevOps, Cloud |
| Batch D | Ep19–24 | Architecture (x2), Microservices, Web3, Security (x2) |
| Batch E | Ep25–30 | Dev Tools, Soft Skills (x2), Project Mgmt (x2), Career |

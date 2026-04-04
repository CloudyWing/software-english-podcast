# Changelog

## v2.0.0

### New Features

- 新增 `podcast-episode` Skill，提供 Episode XML 標準模板、Pattern 選用規則與格式防範規則，供 AI 生成集數內容使用。
- 新增 `podcast-vocab` Skill，定義詞彙缺口評估與分組擴充流程，供定期補充各集單字使用。
- 新增 GitHub Actions `create-release.yml`：push tag 觸發，呼叫 reusable workflow 建立 GitHub Release。
- 新增 GitHub Actions `generate-audio.yml`：Release published 觸發，自動比對前後 tag 差異、呼叫 TTS 腳本轉換變更的 XML，並將 MP3 上傳至 Release Assets（含三次 retry 機制）。
- 擴充全部 30 集詞彙，補充現代技術主流單字、補齊單例句詞彙的第二例句，並依功能領域重新分組。
- `.agent/skills/` 取代原有 `.agent/workflows/` 作為 AI 技能定義目錄。
- 移除舊版 `generate_mock_discussion` workflow。

### BREAKING CHANGES

- `assets/` 目錄已從版控移除，既有 MP3 需從 GitHub Release 下載。

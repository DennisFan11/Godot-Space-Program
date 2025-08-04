# GodotTemplate2D

---

# 資料夾顏色 選擇原則

| 顏色           | 意涵與建議使用情境                                                |
| ------------ | -------------------------------------------------------- |
| 🟦 **藍色系**   | 表示「核心邏輯」、「穩定層」，常用於核心程式碼。建議用於 `Domain`、`Core`             |
| 🟩 **綠色系**   | 表示「純邏輯」、「無副作用」，例如 Domain Model、純函式邏輯等（如 Functional Core） |
| 🟫 **棕色系**   | 若你使用 DDD，可用棕色表示領域模型、實體、值物件等「業務知識」層                       |
| ⚫ **深灰／黑色系** | 表示「架構骨幹」、「不與 UI 交互」，代表基礎但不可或缺                            |
| 🟨 **黃色系**   | 可代表「策略」、「規則集」，適合放入 rule-based 的 Domain 邏輯（例如 AI）         |

---

## CICD
### Itch.io

Deployment to Itch.io is done via [Butler](https://itch.io/docs/butler/).<br>
Secrets needed for a Itch.io deploy via GitLab CI:

|Variable|Description|Example|
|-|-|-|
| ITCHIO_USERNAME | Your username on Itch.io, as in your personal page will be at `https://<username>.itch.io` |`username`
| ITCHIO_GAME | the name of your game on Itchio, as in your game will be available at `https://<username>.itch.io/<game>`  |`game`
| BUTLER_API_KEY | An [Itch.io API key](https://itch.io/user/settings/api-keys) is necessary for Butler so that the CI can authenticate on Itch.io on your behalf. **Make that API key `Masked`(GitLab CI) to keep it secret** |`xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx`
# Godot-Space-Program

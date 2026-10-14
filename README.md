# 丁卓 · 个人主页

一个纯静态的个人主页 —— 零依赖、零构建、单文件，双击 `index.html` 就能跑。

**平面设计风格**：Persona 3 Reload（Dark Hour 纯黑底 / 电光青钴蓝 / 硬边斜切 / 网点纹理 / 描边大字）

---

## 文件说明

| 文件 | 作用 |
| --- | --- |
| `index.html` | **全部内容**：HTML + CSS + JS + 中英文案 + 数字分身知识库，单文件自包含 |
| `preview.cmd` | 双击启动本地预览服务器（自动开浏览器，地址 http://127.0.0.1:8080/） |
| `deploy.cmd` | 双击一键推送到 GitHub Pages，用法：`deploy.cmd 你的GitHub用户名` |
| `.nojekyll` | 告诉 GitHub Pages 不要用 Jekyll 处理，避免静态资源被吞 |

---

## 一、本地预览

**方式 A（最简单）**：直接双击 `index.html`。
所有功能都能用，包括数字分身 —— 它完全在浏览器里运行，不需要网络。

**方式 B（推荐，行为最接近线上）**：双击 `preview.cmd`。
脚本会优先用 Python 起一个本地服务器并自动打开浏览器；没装 Python 就退回 `npx serve`；都没有就直接打开文件。

也可以手动跑：

```powershell
# 在项目目录下
python -m http.server 8080 --bind 127.0.0.1
# 然后访问 http://127.0.0.1:8080/
```

---

## 二、部署到 GitHub Pages（拿到 github.io 网址）

### 目标网址形式

```
https://<你的用户名>.github.io/
```

> 关键点：**仓库名必须正好等于 `<你的用户名>.github.io`**，这样才能拿到不带子路径的根网址。
> 如果仓库叫别的名字（比如 `homepage`），网址会变成 `https://<用户名>.github.io/homepage/`，也能用，只是多一层路径。

### 步骤

1. 在 GitHub 上新建仓库，名字填 `<你的用户名>.github.io`，**不要**勾选 README / .gitignore / license（保持空仓库）。
2. 在本目录双击运行：

```cmd
deploy.cmd <你的用户名>
```

脚本会自动完成 `git init` → `add` → `commit` → `push`，并打印出后续要点的设置项。

3. 打开 `https://github.com/<你的用户名>/<你的用户名>.github.io` → **Settings** → 左侧 **Pages**：
   - **Source** 选 `Deploy from a branch`
   - **Branch** 选 `main`，目录选 `/ (root)`
   - 点 **Save**
4. 等 1–2 分钟，访问 `https://<你的用户名>.github.io/`。

### 手动命令版（不想用脚本时）

```powershell
cd "D:\个人网站"
git init -b main
git add -A
git commit -m "feat: 个人主页 + 数字分身"
git remote add origin https://github.com/<用户名>/<用户名>.github.io.git
git push -u origin main
```

### 更新网站

改完 `index.html` 后：

```powershell
git add -A
git commit -m "update"
git push
```

几十秒后线上自动刷新。GitHub Pages 有缓存，如果没变化，用 `Ctrl+F5` 强制刷新。

---

## 三、数字分身模块

位置：页面「分身」区块（导航栏也有入口）。

**它是什么**：一个跑在浏览器里的**离线人格引擎**。
纯静态站点没法跑真正的 AI 后端，所以这里用的是「关键词加权检索 + 对话状态机」：把丁卓的真实信息拆成 30+ 个知识条目，命中关键词后按权重打分选最匹配的回答。

**技术特性**

- 完全离线，**零网络请求**，不需要 API Key
- 中英双语知识库，跟随页面语言自动切换
- 关键词加权：精确匹配 > 包含匹配 > 前缀模糊匹配，并做了「同话题重复提问」的换句处理
- 回答逐字打字动效 + 思考中指示器
- 快捷追问建议（每条回答下方自动给出下一个可问的问题）
- 可选的语音朗读（浏览器 `speechSynthesis`，点面板右上「语音」）
- 左侧分身形象是 `<canvas>` 程序化绘制的线框肖像，含扫描线、环绕数据点和随机眨眼；颜色跟随主题

**想改成你自己的内容**：搜索代码里的 `const PERSONA = {`，里面的 `zh` / `en` 两个数组就是知识库。每条格式：

```js
{ k:['关键词1','关键词2'], a:'回答内容（支持 <b> <span class="hl"> <code> 等标签）', s:'建议追问的问题' }
```

**以后想接真正的大模型**：在 `avAsk()` 里把返回改成一次 `fetch` 调用你自己的后端即可 —— 但注意不要在前端明文放 API Key，需要一个转发用的服务端函数（Cloudflare Workers / Vercel Functions 都行）。

---

## 四、页面结构

| 区块 | 内容 |
| --- | --- |
| 首屏 | 打字机动效、数据统计（数字滚动）、Java 代码窗 |
| 关于我 | 个人介绍、四条速览信息、名片卡 |
| 技能 | 三栏技能条，滚动进入视口时动画展开 |
| 项目 | 6 张项目卡，按分类筛选，点击查看实现思路弹层 |
| 经历 | 5 条成长时间轴 |
| 爱好 | 中长跑 / 羽毛球 / 看动漫 |
| **分身** | **数字分身对话面板** |
| 博客 | 4 篇学习笔记，点击展开全文 |
| 联系 | 联系方式、社交入口、带校验的留言表单 |

---

## 五、可以继续做的事

- 把 `dingzhuo@example.com` 和 `+86 138-0000-0000` 换成真实联系方式（搜索这两处）
- 社交链接目前是 `href="#"`，换成真实 GitHub / Bilibili / LinkedIn 地址
- 项目卡里的 star 数是示意值，可以改成真实数据
- 想加真实域名：在 GitHub Pages 设置里填 Custom domain，并在域名商处配置 CNAME

# GameDevProject

This repository contains the **public code** for our Godot project.  
Game assets are stored in a **private submodule** so they are only available to collaborators.

---

## 📦 Repositories

- **Public code** → [GameDevProject](https://github.com/O-ElAli/GameDevProject)  
- **Private assets** → [GameDevProjectAssetsPrivate](https://github.com/O-ElAli/GameDevProjectAssetsPrivate) *(collaborators only)*

---

## 🚀 Team Setup

### Prerequisites
- Install [Git](https://git-scm.com/downloads)  
- (Optional) Install [Git LFS](https://git-lfs.com/)  
- Be added as a **collaborator** to both repos

---

### 1. Clone with submodules

#### Option A — First time (recommended)
```bash
git clone --recurse-submodules https://github.com/O-ElAli/GameDevProject.git
cd GameDevProject
```

#### Option B — If you already cloned without submodules
```bash
cd GameDevProject
git submodule update --init --recursive
```

---

### 2. Link `assets` → `assets_private`

Godot expects assets under `res://assets/`.  
We symlink this folder to the private submodule.

#### Windows (PowerShell; run as Admin or with Developer Mode)
```powershell
Remove-Item -Recurse -Force assets -ErrorAction SilentlyContinue
cmd /c mklink /D assets assets_private
```

#### macOS / Linux
```bash
rm -rf assets 2>/dev/null || true
ln -s assets_private assets
```

---

### 3. Verify in Godot
1. Open the project in Godot.  
2. In the **FileSystem dock**, you should see:
   ```
   res://assets/
   ```
   with folders like `bar/`, `bedroom/`, `character/`, etc.  
3. Drag `res://assets/bar/test.png` into a scene to confirm.

---

## 🔄 Daily Workflow

### Pull latest code + assets
```bash
git pull
git submodule update --init --recursive
```

---

## 🎨 Adding or Updating Assets

1. Work inside the private repo:
   ```bash
   cd GameDevProject/assets_private
   # add or edit files under bar/, character/, etc.
   git add <files>
   git commit -m "Add/Update <assets>"
   git push
   ```

2. Bump the submodule pointer in the public repo:
   ```bash
   cd ..
   git add assets_private
   git commit -m "Bump assets_private to latest: <short note>"
   git push
   ```

💡 Why bump? The public repo tracks **which commit** of the private repo it’s using.  
Without this step, others won’t automatically see your asset changes.

---

## 🧹 Git Ignore Rules

Inside the **private repo** (`assets_private/.gitignore`):

```
.import/
*.import
```

- `.import/` → Godot’s cache folder (regenerated automatically)  
- `*.import` → Sidecar import files generated for each asset  

To clear ignored junk:
```bash
git clean -fdX
```

---

## 🛑 Troubleshooting

- **404 when clicking `assets_private` in GitHub:**  
  You’re not a collaborator on the private repo. This is expected for outsiders.

- **Symlink fails on Windows:**  
  - Run PowerShell as **Administrator**  
  - Or enable **Developer Mode** in Windows settings.

- **Submodule broken / missing mapping:**  
  Reset and re-add:
  ```bash
  rmdir /S /Q assets_private 2>NUL
  rmdir /S /Q .git\modulesssets_private 2>NUL
  git config -f .git/config --remove-section submodule.assets_private 2>NUL
  git submodule add https://github.com/O-ElAli/GameDevProjectAssetsPrivate.git assets_private
  git commit -m "Re-add assets submodule"
  ```

---

## ✅ Summary

- Code = public repo  
- Assets = private repo  
- Godot always uses `res://assets/...`  
- Teammates must clone with `--recurse-submodules` and set up the `assets` symlink  
- Outsiders see the code but cannot access assets (private repo returns 404)

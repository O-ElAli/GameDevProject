# GameDevProject

This repository contains the **public code** for our Godot project.  
Game assets live in a **private Git submodule** checked out as a **real folder** (`assets/`) — no symlinks — so Godot’s file watcher behaves correctly.

---

## 📦 Repositories

- **Public code** → `GameDevProject`  
- **Private assets** → `GameDevProjectAssetsPrivate` *(collaborators only)*

---

## 🚀 Team Setup

### Prerequisites
- Install [Git](https://git-scm.com/downloads)  
- (Optional) Install [Git LFS](https://git-lfs.com/) if the assets repo uses it  
- Be added as a **collaborator** to both repos

### 1) Clone with submodules
```bash
git clone --recurse-submodules https://github.com/O-ElAli/GameDevProject.git
cd GameDevProject
```

If you already cloned without submodules:
```bash
git submodule update --init --recursive
```

### 2) Ensure assets submodule is a real folder at `assets/` (no symlink)
We keep the private assets repo **mounted directly at `assets/`** to avoid Godot reloading issues with symlinks.

If you previously had a symlink named `assets` → `assets_private`, delete it (safe; it won’t touch your real files):
- **Windows (PowerShell/cmd):**
  ```bat
  rmdir assets
  ```
- **macOS/Linux:**
  ```bash
  rm assets
  ```

> The assets submodule path should be `assets/`. If your submodule currently lives at `assets_private/`, migrate it once (guide below).

---

## 🔧 One‑time: make the submodule track `main`

From the repo root:
```bash
git submodule set-branch --branch main assets
git submodule sync --recursive
git submodule update --init --remote --recursive
git add .gitmodules assets
git commit -m "Track assets submodule on main; initialize to latest"
```

This records that the submodule should follow the **`main`** branch when we update with `--remote`.

---

## ⚡ Optional quality-of-life

Add a handy alias to always pull code + latest assets:

```bash
git config alias.update-all "!git pull --recurse-submodules && git submodule update --remote --recursive"
```

Now you can just run:
```bash
git update-all
```

---

## 🔄 Daily Workflow

### Pull latest code + assets
```bash
git update-all
# or, without the alias:
# git pull --recurse-submodules
# git submodule update --remote --recursive
```

### Make code changes (public repo)
```bash
# edit code...
git add <files>
git commit -m "Your message"
git push
```

### Add or update assets (private repo)
```bash
cd assets
# add/edit under bar/, character/, etc.
git add <files>
git commit -m "Add/Update <assets>"
git push
cd ..
# record the new submodule commit in the public repo so teammates get it
git add assets
git commit -m "Bump assets submodule to latest main"
git push
```

> **Why bump?** The public repo pins an exact assets commit. Committing the submodule pointer tells others which assets revision to use.

---

## 🧭 Migration: move submodule from `assets_private/` → `assets/` (do once)

If your project currently has the submodule at `assets_private/` and a symlink `assets` → `assets_private`, do this **once**:

**1) Remove the symlink (do NOT delete the real folder):**
- Windows:
  ```bat
  rmdir assets
  ```
- macOS/Linux:
  ```bash
  rm assets
  ```

**2) If `assets_private/` is the real folder, rename it to `assets/`:**
- Windows:
  ```bat
  ren assets_private assets
  ```
- macOS/Linux:
  ```bash
  mv assets_private assets
  ```

**3) Update Git metadata so the submodule path is `assets`:**
```bash
# Rewrite the submodule path in config files
git rm --cached assets -r 2>NUL || true
git rm --cached assets_private -r 2>NUL || true

# If your .gitmodules contains 'assets_private', change it to 'assets':
# [submodule "assets"]
#   path = assets
#   url  = https://github.com/O-ElAli/GameDevProjectAssetsPrivate.git

git add .gitmodules assets
git commit -m "Move submodule to 'assets' path (no symlink)"
```

**4) Ensure branch tracking + latest revision:**
```bash
git submodule set-branch --branch main assets
git submodule sync --recursive
git submodule update --init --remote --recursive
git add assets .gitmodules
git commit -m "Track assets on main; update to latest"
git push
```

> After this, Godot will see `res://assets/` as a normal directory and won’t over-reload on tab focus.

---

## 🧹 Git ignore rules (inside assets repo)

In `assets/.gitignore` (i.e., the private repo):
```
.import/
*.import
```
- `.import/` → Godot’s cache (auto-regenerated)  
- `*.import` → Godot sidecar import files

To clean ignored junk safely:
```bash
git clean -fdX
```

---

## 🛠 Troubleshooting

- **Detached HEAD in submodule**
  - Cause: `git submodule update` without `--remote` pins to a commit.
  - Fix: `git submodule update --remote --recursive` or use `git update-all` alias.
  - Then commit the bump in the parent repo.

- **Teammate doesn’t see new assets**
  - They need the commit that bumped the submodule pointer.
  - Run: `git pull` (parent) → `git submodule update --init --remote --recursive`.

- **Large binaries**
  - Use Git LFS in the assets repo:
    ```bash
    git lfs track "*.png" "*.wav" "*.ogg" "*.fbx" "*.glb"
    git add .gitattributes
    git commit -m "Use LFS for binaries"
    git push
    ```

- **Windows symlink errors**
  - Not needed anymore since we don’t use symlinks. If you still have legacy links, remove them with `rmdir <link>`.

---

## ✅ Summary

- Assets live at **`assets/`** as a **submodule** (no symlinks).  
- Use `git update-all` (alias) to fetch latest code + assets.  
- When you change assets, **push the assets repo** and **commit the bump** in the parent repo.

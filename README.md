# Poker Course Advanced — Docs

Static documentation site powered by **MkDocs + Material**.

## Prerequisites

- **Windows 11** (dev machine)
- **Python 3.10+** with `pip`
- **MkDocs + Material**
  ```powershell
  pip install mkdocs mkdocs-material
  ```
- (Optional) If you use custom plugins/extensions, install them too.

## Project Structure

```
poker-course-advanced/
├─ mkdocs.yml
├─ docs/
│  ├─ 01-introduction.md
│  ├─ 02-poker-basics.md
│  ├─ 03-hand-rankings.md
│  ├─ 04-core-strategies.md
│  ├─ 05-advanced-plays.md
│  ├─ 06-common-mistakes.md
│  ├─ 07-practice-drills.md
│  ├─ 08-fish-play.md
│  ├─ 09-preflop-stats.md
│  ├─ strategy/index.md           # (optional) section index with icon
│  ├─ fundamentals/index.md       # (optional) section index with icon
│  ├─ images/
│  └─ css/
│     ├─ player-types.css
│     └─ nav-style.css
├─ site/                          # build output (generated)
└─ deploy.ps1                     # one-click build + upload
```

---

## Local Preview (Hot Reload)

```powershell
cd path\to\poker-course-advanced
mkdocs serve
```

Open `http://127.0.0.1:8000/` in your browser.  http://127.0.0.1:8000/ 
Every time you save a file in `docs/`, the site auto-refreshes.

> Tip: If a CSS change doesn’t show, hard refresh (Ctrl+F5). With `navigation.instant` enabled, assets can be cached aggressively.

---

## Editing Content

1. Add or edit Markdown files under `docs/`.
2. Update navigation in `mkdocs.yml`.
3. (Optional) Add an icon to a page by putting this **front matter** at the very top:
   ```markdown
   ---
   icon: material/chart-line
   ---
   ```

### Side-by-side content (two columns)
Use HTML with `markdown="1"`.

---

## Styling & Theme

https://pictogrammers.com/library/mdi/

- **Light/Dark palette** is set in `mkdocs.yml` (`theme.palette`).
- Custom CSS:
  - `docs/css/player-types.css` — colored “player type” cards.
  - `docs/css/nav-style.css` — nav highlights and dark-mode tweaks.

---

## Build

```powershell
mkdocs build
```

---

## Deploy (One Command)

`deploy.ps1` builds, backs up the live site, and uploads the new build to the server.

1. Open `deploy.ps1` and set:
   ```powershell
   $serverUser = "your_ssh_user"
   $serverHost = "your.server.ip.or.host"
   $serverPort = "22"
   $remoteDir  = "/var/www/poker-course-advanced"
   $backupDir  = "/var/www/poker-course-advanced-backups"
   ```
2. Run:
   ```powershell
   .\deploy.ps1
   ```

It will:
- `mkdocs build`
- Backup the current site on the server
- Upload `site/*` to `$remoteDir`
- Print rollback instructions

**Rollback:**
```bash
ssh user@host -p 22
rm -rf /var/www/poker-course-advanced/*
cp -r /var/www/poker-course-advanced-backups/backup_YYYYMMDD_HHMMSS/* /var/www/poker-course-advanced/
```

---

## Nginx Example

```nginx
location ^~ /docs/ {
    alias /var/www/poker-course-advanced/;
    try_files $uri $uri/ /docs/index.html;
}
```

Reload:
```bash
sudo nginx -t && sudo systemctl reload nginx
```

---

## Optional: Login

Basic Auth example:

```nginx
location ^~ /docs/ {
    auth_basic "Restricted Area";
    auth_basic_user_file /etc/nginx/.htpasswd;
    alias /var/www/poker-course-advanced/;
    try_files $uri $uri/ /docs/index.html;
}
```

---

## Troubleshooting

- **Icons not showing in nav** — Use `icon: material/...` in page front matter.
- **CSS not applying** — Hard refresh or temporarily disable `navigation.instant`.
- **Side-by-side lists not rendering** — Ensure `md_in_html` is enabled in `markdown_extensions`.

---

## Useful Commands

```powershell
mkdocs serve
mkdocs build
.\deploy.ps1
```

---

## License / Notes

Internal course material for Poker Course Advanced.

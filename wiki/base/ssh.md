# Настройка Git + SSH для команды

Эта инструкция — для **каждого участника команды**, кто клонирует и пушит в репозиторий проекта. Каждый настраивает у себя один раз, на своей машине.

**Идея схемы:** один SSH-ключ на устройство, с собственным (не дефолтным) именем — чтобы не путаться, если ключей несколько. Ключ используется **и для доступа** (`git push`/`pull`), **и для подписи коммитов** (вместо отдельного GPG). На GitHub он добавляется **дважды**: как Authentication Key и как Signing Key.

Везде ниже вместо `<username>` подставляй своё имя/ник, вместо `<email>` — свою почту (должна совпадать с verified email в твоём GitHub-аккаунте), вместо `<org>/<repo>` — реальный адрес репозитория проекта.

---

## 1. Установка Git

### Windows

При установке **Git for Windows** обрати внимание на эти пункты:

- **Select Components:**
  - ✅ Windows Explorer integration → Open Git Bash here
  - ✅ Git LFS (Large File Support)
  - ✅ Associate .git* configuration files with the default text editor
  - ✅ Associate .sh files to be run with Bash
  - ✅ Scalar (Git add-on to manage large-scale repositories)
  - Остальное — по желанию, не критично

- **Adjusting the name of the initial branch:**
  **Override the default branch name for new repositories** → `main`
  (иначе новые локальные репозитории будут создаваться с веткой `master`, что не совпадает с GitHub)

- **Adjusting your PATH environment:**
  **Git from the command line and also from 3rd-party software** (значение по умолчанию)

- **Choosing HTTPS transport backend:**
  **Use the OpenSSL library**

- **Configuring line ending conversions:**
  **Checkout as-is, commit Unix-style line endings** (`core.autocrlf=input`)
  Это важно, если в команде есть люди на разных ОС (Windows/Linux/macOS) — исключает лишний шум в диффах из-за окончаний строк.

- **Configuring the terminal emulator for Git Bash:**
  **Use MinTTY** (по умолчанию)

- **Choose the default behavior of `git pull`:**
  **Merge** (по умолчанию, самый безопасный вариант — ничего не переписывается)

- **Choose a credential helper:**
  **Git Credential Manager** (по умолчанию — не придётся вводить логин/токен на каждую операцию)

- **Configuring extra options:**
  - ✅ Enable file system caching
  - ✅ Enable symbolic links

### Linux/macOS

Ставится через пакетный менеджер (`apt`, `pacman`, `brew`, `nix` и т.д.) — отдельных пунктов настройки как в Windows-инсталляторе нет, но полезно сразу выставить то же самое вручную:

```bash
git config --global init.defaultBranch main
git config --global core.autocrlf input
git config --global pull.rebase false
```

---

## 2. Создание SSH-ключа

**Linux/macOS:**
```bash
ssh-keygen -t ed25519 -C "<email>" -f ~/.ssh/github_<username>
```

**Windows (PowerShell):**
```powershell
ssh-keygen -t ed25519 -C "<email>"
```

На запрос passphrase — обязательно задать пароль (не оставлять пустым).

### Настройка агента (один раз на машину)

**Linux/macOS:** ничего заранее включать не нужно, агент запускается по требованию (см. ниже).

**Windows — обязательно один раз, от администратора:**
```powershell
Get-Service -Name ssh-agent | Set-Service -StartupType Automatic
Start-Service ssh-agent
```
Без этого шага `ssh-add` не сработает — служба `ssh-agent` в Windows по умолчанию выключена.

### Добавление ключа в агент

**Linux/macOS:**
```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_<username>
```
На macOS — с сохранением passphrase в Keychain:
```bash
ssh-add --apple-use-keychain ~/.ssh/github_<username>
```

**Windows (обычное окно, без прав администратора):**
```powershell
ssh-add $env:USERPROFILE\.ssh\github_<username>
```

### Конфиг `~/.ssh/config`

Путь: `~/.ssh/config` на Linux/macOS, `C:\Users\<user>\.ssh\config` на Windows.

```
Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/github_<username>
```

`UseKeychain yes` актуально только для macOS — на Windows/Linux обычно просто игнорируется. Если появится ошибка `Bad configuration option: usekeychain` — удали эту строку.

**Windows-нюанс:** если passphrase сохранён в системном агенте, а Git всё равно просит его при `git push` — значит Git for Windows использует свой `ssh.exe` вместо системного OpenSSH-клиента. Фикс:
```powershell
git config --global core.sshCommand "C:/Windows/System32/OpenSSH/ssh.exe"
```

---

## 3. Добавление ключа в GitHub (доступ к репозиторию)

```bash
cat ~/.ssh/github_<username>.pub
```
Windows: `type $env:USERPROFILE\.ssh\github_<username>.pub`

Скопировать вывод → **GitHub → Settings → SSH and GPG keys → New SSH key**:
- **Key type:** `Authentication Key`
- Вставить содержимое `.pub`

Также нужно, чтобы владелец репозитория добавил тебя в участники организации/репозитория (Settings репозитория → Collaborators, или через приглашение в организацию) — сам ключ доступа не даёт, только подтверждает "это точно ты".

Проверка ключа:
```bash
ssh -T git@github.com
```
Ожидаемый ответ: `Hi <username>! You've successfully authenticated...`

---

## 4. Тот же ключ — для подписи коммитов

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/github_<username>.pub
git config --global commit.gpgsign true
git config --global tag.gpgsign true
```

Добавить **этот же публичный ключ на GitHub второй раз**, с другим типом:
- **GitHub → Settings → SSH and GPG keys → New SSH key**
- **Key type:** `Signing Key`
- Вставить тот же `.pub`

Без этого шага коммиты будут подписываться локально, но GitHub не покажет "Verified".

**Важно:** email в `git config user.email` должен совпадать с одним из verified email на GitHub:
```bash
git config --global user.email "<email>"
```

---

## 5. Клонирование репозитория и работа

```bash
git clone git@github.com:<org>/<repo>.git
cd <repo>
# ... правки ...
git add .
git commit -m "message"   # подпишется автоматически
git push
```

Проверка подписи:
```bash
git log --show-signature -1
```
На GitHub рядом с коммитом появится зелёная плашка **Verified**.

---

## 6. Отдельно: классический GPG-ключ (если понадобится)

Не связан со схемой выше — нужен, только если у кого-то в команде уже есть привычный GPG-ключ или того требует внешняя политика.

### Генерация
```bash
gpg --full-generate-key
```
- Тип: `RSA and RSA`, размер `4096`
- Срок действия: 1–2 года (не "бессрочно")
- Email — совпадает с verified email на GitHub

### Экспорт публичного ключа
```bash
gpg --list-secret-keys --keyid-format=long
gpg --armor --export <KEY_ID>
```
Весь блок (`-----BEGIN PGP PUBLIC KEY BLOCK-----` ... `END`) → **GitHub → Settings → SSH and GPG keys → New GPG key**.

### Переключить git с SSH-подписи обратно на GPG
```bash
git config --global --unset gpg.format
git config --global user.signingkey <KEY_ID>
git config --global commit.gpgsign true
git config --global tag.gpgsign true
```

### Частые проблемы

**`gpg failed to sign the data`** — gpg не находит tty:
```bash
echo 'export GPG_TTY=$(tty)' >> ~/.zshrc   # или ~/.bashrc
```

**Не показывается окно ввода пароля (macOS):**
```bash
brew install pinentry-mac
echo "pinentry-program $(which pinentry-mac)" >> ~/.gnupg/gpg-agent.conf
killall gpg-agent
```

**Срок действия истёк:**
```bash
gpg --edit-key <KEY_ID>
gpg> expire
gpg> save
```
После продления — заново экспортировать и обновить публичный ключ на GitHub.

---

## Доп. материалы (GitHub Docs)
- [Расскажите Git о ключе для подписывания](https://docs.github.com/ru/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key)
- [Создание нового SSH-ключа и добавление в ssh-agent](https://docs.github.com/ru/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

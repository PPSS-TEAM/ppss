# Настройки репозитория GitHub — гайд для команды

Документ описывает разделы **Settings** репозитория GitHub на примере репозитория `ppss` (организация `PPSS-TEAM`), с пояснениями что делает каждая настройка и текущим состоянием на момент составления (29.08.2026).

Официальная документация GitHub по теме: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features

---

## 1. General

### Repository name
Поле с текущим именем репозитория (`ppss`) + кнопка **Rename**. После переименования GitHub создаёт редиректы со старых URL/git remote на новые, но CI/CD-интеграции, вебхуки и внешние ссылки на raw-файлы стоит проверить вручную.

### Template repository
Делает репозиторий шаблоном — другие смогут создавать новые репозитории с той же структурой файлов (кнопка "Use this template" вместо форка). Полезно для стандартного boilerplate под новые проекты команды.

### Default branch
Ветка, которая считается "базовой": в неё по умолчанию мержатся PR, она открывается при заходе в репозиторий. Сейчас — `main`.
- значок карандаша — переименовать саму ветку;
- значок ⇄ — сменить, какая ветка дефолтная.

### Releases → Enable release immutability
Запрещает менять файлы и теги релиза после публикации — гарантия, что опубликованный релиз всегда содержит именно те файлы, что были выпущены. Полезно для аудита/безопасности.

### Features
| Фича | Статус | Что делает |
|---|---|---|
| Wikis | 🔒 недоступно | На приватном репо в текущем тарифе выключено — нужен либо публичный репозиторий, либо апгрейд плана организации |
| Issues | выкл | Трекер задач/багов с лейблами и milestone |
| Allow forking | выкл | Разрешает делать форки репозитория |
| Sponsorships | выкл | Кнопка "Sponsor" для донатов — не актуально для рабочего проекта |
| Discussions | выкл | Форум/Q&A внутри репозитория, отдельно от Issues |
| Projects | выкл | Канбан-доски уровня организации, привязываются к репозиторию |
| Pull requests | ✅ вкл | Разрешение предлагать изменения через PR. Ниже — **Pull request permissions: Creation allowed by All users** |

### Pull Requests — способы мержа
Все три включены:
- **Allow merge commits** — добавляет все коммиты ветки в base-ветку через merge commit, сохраняя полную историю.
- **Allow squash merging** — сжимает все коммиты PR в один коммит при мерже.
- **Allow rebase merging** — переносит коммиты по одному поверх base-ветки, без merge-коммита.

Для каждого способа можно задать **Default commit message** — шаблон сообщения коммита при мерже.

Далее:
- **Always suggest updating pull request branches** (выкл) — при появлении новых изменений в base-ветке предлагать кнопку "Update branch" в PR.
- **Allow auto-merge** (выкл) — PR смержится сам, как только пройдут обязательные ревью/проверки.
- **Automatically delete head branches** (выкл) — ветка-источник PR удаляется автоматически после мержа (можно восстановить).

### Commits
- **Require contributors to sign off on web-based commits** (выкл) — требовать подпись DCO (Developer Certificate of Origin) для коммитов через веб-интерфейс GitHub.
- **Allow comments on individual commits** (✅ вкл) — разрешает комментировать конкретные коммиты.

### Archives
- **Include Git LFS objects in archives** (выкл) — включать ли LFS-файлы (Large File Storage) при скачивании архива репозитория (zip/tar). Актуально только если используется Git LFS.

### Danger Zone
- **Change repository visibility** — сейчас **Private**.
- **Disable branch protection rules** — массово отключить все правила защиты веток.
- **Transfer ownership** — передать репозиторий другому пользователю/организации.
- **Archive this repository** — сделать репозиторий read-only.
- **Delete this repository** — необратимое удаление.

---

## 2. Access → Collaborators and teams
- Репозиторий приватный, доступен только тем, у кого есть права.
- **Base role: Write** — базовая роль для всех участников организации (4 человека).
- **Direct access**: 4 человека — `bekirou` (mixed roles/maintain), `gggkotik` (write), `SankoSansanovich` (write), `tatpow` (admin).
- **Organization access**: 0 команд имеют доступ через организацию.

Роли по возрастанию прав: Read → Triage → Write → Maintain → Admin.

---

## 3. Code, planning и automation

### Rulesets
Новый, более гибкий механизм защиты веток/тегов — приходит на замену classic branch protection. В отличие от классических правил:
- можно комбинировать несколько rulesets, применяется самое строгое условие;
- rulesets можно включать/выключать без удаления (в т.ч. в тестовом режиме evaluate);
- видны на чтение всем с доступом к репозиторию, а не только админам.

⚠️ У нас **rulesets не созданы**, и даже если создать — они не будут применяться, пока организация не перейдёт на план **GitHub Team** (ограничение для приватных репо на текущем тарифе).

### Branches → Branch protection rules (classic)
Старый механизм защиты веток: запрет force-push, запрет удаления ветки, обязательные PR + ревью перед мержем, обязательные status checks и т.п. У нас **не настроены**.
Документация: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule

### Tags → Protected tags
GitHub объявил, что классическая защита тегов **устаревает** — рекомендуется переходить на Tag Rulesets. У нас protected tags не настроены (и сама фича помечена как deprecated).

### Actions → Actions permissions
Выбрано: **Disable actions** — вкладка Actions скрыта, ни один workflow не запускается.
Варианты выбора:
- Allow all actions and reusable workflows — разрешить вообще всё;
- Disable actions — полностью выключить (наш вариант);
- Allow `PPSS-TEAM` actions and reusable workflows — разрешить только actions из репозиториев организации;
- Allow `PPSS-TEAM` и выборочно сторонние — гибрид с white-list.

Также:
- **Require actions to be pinned to a full-length commit SHA** (выкл) — требование указывать конкретный коммит вместо тега/ветки для сторонних actions (защита от подмены версии).
- **Artifact and log retention: 90 дней** — максимум, заданный на уровне организации.
- **Run workflows from fork pull requests** (выкл) — по умолчанию workflow не запускаются из форков (защита от вредоносного кода в внешних PR).

### Actions → General → Workflow permissions
- **Read repository contents and packages permissions** — токен `GITHUB_TOKEN` в workflow имеет только read-доступ (альтернатива — read+write на все скоупы).
- **Allow GitHub Actions to create and approve pull requests** (выкл).
- **Access**: **Not accessible** — workflow'ы других репозиториев организации не могут обращаться к этому репо (альтернатива — открыть для `PPSS-TEAM`).

### Webhooks
Не показано на скринах, но раздел присутствует в меню — позволяет настраивать HTTP-уведомления во внешние системы при событиях в репозитории (push, PR, issue и т.д.).

### Copilot
Раздел настроек GitHub Copilot для репозитория (не разворачивали на скринах).

### Planning → Agent suggestions for issues
Новая AI-фича: агент анализирует входящие issues и предлагает лейблы, приоритет, исполнителя и прочие метаданные.
Уровни автоматизации:
- **Full control** — всё держится на ревью, ничего не применяется само;
- **Cautious** (наш вариант) — применяются только изменения с высокой уверенностью, остальное на ревью;
- **Balanced** — применяются рутинные однозначные изменения, спорное — на ревью;
- **Full automation** — применяется всё, кроме помеченного как "неопределённое".

### Environments
Используются workflow'ами для деплоя (staging/production и т.п.) — задают правила подтверждения деплоя, секреты окружения. У нас окружений пока нет.

### Pages
GitHub Pages недоступен на текущем тарифе для приватного репозитория (то же ограничение, что и у Wiki) — нужен публичный репозиторий или апгрейд. В GitHub Enterprise есть возможность приватной публикации Pages.

### Custom properties
Кастомные метаданные репозитория (compliance framework, чувствительность данных, детали проекта). У нас не заданы.

---

## 4. Security and quality

### Advanced Security
Ничего не включено:
- **Dependency graph** — карта используемых зависимостей проекта.
- **Dependabot alerts** — уведомления об уязвимых зависимостях (сверяется с GitHub Advisory Database).
- **Dependabot security updates** — при включении Dependabot сам открывает PR с минимальным патчем, устраняющим уязвимость.
- **Grouped security updates** — объединяет все патчи одного пакетного менеджера/директории в один PR вместо кучи мелких.
- **Dependabot version updates** — отдельная фича: обновляет зависимости до новых версий даже без уязвимостей, требует файл `dependabot.yml`.

Коротко про разницу: alerts — просто предупреждают, security updates — чинят уязвимости автоматически через PR, version updates — держат зависимости свежими вообще (не только про уязвимости).
Документация: https://docs.github.com/en/code-security/dependabot

### Code quality
Не включено. При включении: разовое сканирование дефолтной ветки + сканирование каждого PR (в т.ч. с AI-находками), тратит action-минуты, генерирует YAML для code coverage.

### Deploy keys
🔒 Отключено политикой организации `PPSS-TEAM` — организация решила не использовать deploy keys, а рекомендует GitHub Apps для более гранулярного контроля доступа.
Deploy key — это SSH-ключ, привязанный к одному конкретному репозиторию (а не к пользователю), даёт read или read+write доступ. Минус: при работе с несколькими репозиториями ключи приходится плодить и вручную ротировать. GitHub Apps в этом смысле удобнее — используют короткоживущие токены и гранулярные права.

### Secrets and variables → Actions
- **Environment secrets** — секреты, привязанные к конкретному environment (например, продовые ключи).
- **Repository secrets** — секреты уровня репозитория. У нас нет ни тех, ни других.
- **Organization secrets** — доступны только публичным репозиториям на текущем тарифе; чтобы шарить секреты организации с приватными репо, нужен апгрейд плана.
Секреты — зашифрованы (для чувствительных данных: токены, пароли), переменные (Variables) — хранятся в открытом виде (для не чувствительных данных типа окружения/URL).

---

## 5. Справочно: Rulesets vs Branch Protection Rules — когда что использовать

- **Branch protection rules (classic)** — просто и быстро для одной-двух важных веток (`main`, `release/*`). Не умеет запрещать создание веток с "неправильными" именами.
- **Rulesets** — более новый и гибкий подход: можно централизованно задавать паттерны имён веток/тегов (`feature/*`, `hotfix/*`), комбинировать несколько наборов правил, включать/выключать без удаления, давать bypass конкретным ролям/командам/GitHub Apps. Подходит, когда репозиториев/веток много и нужна единая политика.

У нас пока не настроено ни то, ни другое — стоит взять в бэклог, особенно если начнём подключать Actions и потребуется защита `main` от прямых пушей.

---

## Источники
- Официальная документация GitHub — Managing repository settings: https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features
- About rulesets / Available rules for rulesets: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/available-rules-for-rulesets
- Managing a branch protection rule: https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/managing-a-branch-protection-rule
- Dependabot alerts / security updates / version updates: https://docs.github.com/en/code-security/dependabot
- Restricting deploy keys in your organization: https://docs.github.com/en/organizations/managing-organization-settings/restricting-deploy-keys-in-your-organization
- GitHub Apps overview (почему предпочтительнее OAuth apps / deploy keys для гранулярного доступа): https://docs.github.com/en/apps/overview

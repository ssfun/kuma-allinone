# Open WebUI Dockerfile for Choreo

# Version

v0.8.1

# Releases

## [0.8.1] - 2026-02-14

> [!CAUTION]
> ⚠️ **Database Migrations**: This release includes database schema changes; we strongly recommend backing up your database and all associated data before upgrading in production environments. If you are running a multi-worker, multi-server, or load-balanced deployment, all instances must be updated simultaneously, rolling updates are not supported and will cause application failures due to schema incompatibility.

### Added

- 🚀 **Channel user active status.** Checking user active status in channels is now faster thanks to optimized database queries. [Commit](https://github.com/open-webui/open-webui/commit/ca6b18ab5cb94153a9dae233f975d36bf6b19b76)
- 🔗 **Responses API endpoint with model routing.** The OpenAI API proxy now supports a /responses endpoint that routes requests to the correct backend based on the model field in the request, instead of always using the first configured endpoint. This enables support for backends like vLLM that provide /skills and /v1/responses endpoints. [Commit](https://github.com/open-webui/open-webui/commit/abc9b63093d65f4d74342db85b7d5df1809aa0f0), [Commit](https://github.com/open-webui/open-webui/commit/79ecbfc757f0642740d0e44fab98263d84295490)
- ⚡ **Model and prompt list optimization.** Improved performance when loading models and prompts by pre-fetching user group IDs once instead of making multiple database queries. [Commit](https://github.com/open-webui/open-webui/commit/20de5a87da0c12e4052b50887a42ddd7228c5ef5)
- 🗄️ **Batch access control queries.** Improved performance when loading models, prompts, and knowledge bases by replacing multiple individual access checks with single batch queries, significantly reducing database load for large deployments. [Commit](https://github.com/open-webui/open-webui/commit/589c4e64c1b7bb7a7a5abc20382b92fb860e28c2)
- 💨 **Faster user list loading.** User lists now load significantly faster by deferring profile image loading; images are fetched separately in parallel by the browser, improving caching and reducing database load. [Commit](https://github.com/open-webui/open-webui/commit/b7549d2f6ca2843661ec79a5a1e55da9e7553368)
- 🔍 **Web search result count.** The built-in search_web tool now respects the admin-configured "Search Result Count" setting instead of always returning 5 results when using Native Function Calling mode. [#21373](https://github.com/open-webui/open-webui/pull/21373), [#21371](https://github.com/open-webui/open-webui/issues/21371)
- 🔐 **SCIM externalId support.** SCIM-enabled deployments can now store and manage externalId for user provisioning, enabling better integration with identity providers like Microsoft Entra ID and Okta. [#21099](https://github.com/open-webui/open-webui/pull/21099), [#21280](https://github.com/open-webui/open-webui/issues/21280), [Commit](https://github.com/open-webui/open-webui/commit/d1d1efe212b16e0052359991d67fd813125077e8)
- 🌐 **Translation updates.** Portuguese (Brazil) translations were updated.

### Fixed

- 🛡️ **Public sharing security fix.** Fixed a security issue where users with write access could see the Public sharing option regardless of their actual public sharing permission, and direct API calls could bypass frontend sharing restrictions. [#21358](https://github.com/open-webui/open-webui/pull/21358), [#21356](https://github.com/open-webui/open-webui/issues/21356)
- 🔒 **Direct model access control fix.** Model access control changes now persist correctly for direct Ollama and OpenAI models that don't have database entries, and error messages display properly instead of showing "[object Object]". [Commit](https://github.com/open-webui/open-webui/commit/f027a01ab2ff3b6175af3dd13a4478c265c0544a), [#21377](https://github.com/open-webui/open-webui/issues/21377)
- 💭 **Reasoning trace rendering performance.** Reasoning traces from models now render properly without being split into many fragments, preventing browser slowdowns during streaming responses. [#21348](https://github.com/open-webui/open-webui/issues/21348), [Commit](https://github.com/open-webui/open-webui/commit/3b61562c82448cf83710d8b6ed29b797991aa83a)
- 🖥️ **ARM device compatibility fix.** Fixed an issue where upgrading to 0.8.0 would fail to start on ARM devices (like Raspberry Pi 4) due to torch 2.10.0 causing SIGILL errors; now pinned to torch<=2.9.1. [#21385](https://github.com/open-webui/open-webui/pull/21385), [#21349](https://github.com/open-webui/open-webui/issues/21349)
- 🗄️ **Skills PostgreSQL compatibility fix.** Fixed a PostgreSQL compatibility issue where creating or listing skills would fail with a TypeError, while SQLite worked correctly. [#21372](https://github.com/open-webui/open-webui/pull/21372), [Commit](https://github.com/open-webui/open-webui/commit/b4c3f54f9648c4232a0fd6557703ffa66fcf4caa), [#21365](https://github.com/open-webui/open-webui/issues/21365)
- 🗄️ **PostgreSQL analytics query fix.** Fixed an issue where retrieving chat IDs by model ID would fail on PostgreSQL due to incompatible DISTINCT ordering, while SQLite worked correctly. [#21347](https://github.com/open-webui/open-webui/issues/21347), [Commit](https://github.com/open-webui/open-webui/commit/7bda6bf767d5d5c4dc1111465096a88e10b5030e)
- 🗃️ **SQLite cascade delete fix.** Deleting chats now properly removes all associated messages in SQLite, matching PostgreSQL behavior and preventing orphaned data. [#21362](https://github.com/open-webui/open-webui/pull/21362)
- ☁️ **Ollama Cloud model naming fix.** Fixed an issue where using Ollama Cloud models would fail with "Model not found" errors because ":latest" was incorrectly appended to model names. [#21386](https://github.com/open-webui/open-webui/issues/21386)
- 🛠️ **Knowledge selector tooltip z-index.** Fixed an issue where tooltips in the "Select Knowledge" dropdown were hidden behind the menu, making it difficult to read knowledge item names and descriptions. [#21375](https://github.com/open-webui/open-webui/pull/21375)
- 🎯 **Model selector scroll position.** The model selector dropdown now correctly scrolls to and centers the currently selected model when opened, and resets scroll position when reopened. [Commit](https://github.com/open-webui/open-webui/commit/0b05b2fc7ed4c38af158707438ff404d1beb7c91)
- 🐛 **Sync modal unexpected appearance.** Fixed an issue where the Sync Modal would appear unexpectedly after enabling the "Community Sharing" feature if the user had previously visited the app with the sync parameter. [#21376](https://github.com/open-webui/open-webui/pull/21376)
- 🎨 **Knowledge collection layout fix.** Fixed a layout issue in the Knowledge integration menu where long collection names caused indentation artifacts and now properly truncate with ellipsis. [#21374](https://github.com/open-webui/open-webui/pull/21374)
- 📝 **Metadata processing crash fix.** Fixed a latent bug where processing document metadata containing certain keys (content, pages, tables, paragraphs, sections, figures) would cause a RuntimeError due to dictionary mutation during iteration. [#21105](https://github.com/open-webui/open-webui/pull/21105)
- 🔑 **Password validation regex fix.** Fixed the password validation regex by adding the raw string prefix, ensuring escape sequences like d and w are interpreted correctly. [#21400](https://github.com/open-webui/open-webui/pull/21400), [#21399](https://github.com/open-webui/open-webui/issues/21399)

### Changed

- ⚠️ **Database Migrations:** This release includes database schema changes; we strongly recommend backing up your database and all associated data before upgrading in production environments. If you are running a multi-worker, multi-server, or load-balanced deployment, all instances must be updated simultaneously, rolling updates are not supported and will cause application failures due to schema incompatibility.
# Changelog

## [1.18.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.17.3...v1.18.0) (2026-04-14)


### Features

* comment on Jira when no SDK changes needed ([#89](https://github.com/viamrobotics/claude-ci-workflows/issues/89)) ([395cf70](https://github.com/viamrobotics/claude-ci-workflows/commit/395cf70a7e1beaea4059d9a0bd47e6f663a320fb))

## [1.17.3](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.17.2...v1.17.3) (2026-04-08)


### Bug Fixes

* prevent dependabot sweep from promoting transitive deps to direct ([#87](https://github.com/viamrobotics/claude-ci-workflows/issues/87)) ([52ed2fb](https://github.com/viamrobotics/claude-ci-workflows/commit/52ed2fb780da78b1bedb95af2e40c4dcaf580b38))

## [1.17.2](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.17.1...v1.17.2) (2026-04-08)


### Bug Fixes

* bump claude-code-action to v1.0.90 and enable display_report ([#85](https://github.com/viamrobotics/claude-ci-workflows/issues/85)) ([923800f](https://github.com/viamrobotics/claude-ci-workflows/commit/923800f4b6e2ba992f476df21ac71b261de818a0))

## [1.17.1](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.17.0...v1.17.1) (2026-04-08)


### Bug Fixes

* fall back to title search when branch_name output is empty ([#83](https://github.com/viamrobotics/claude-ci-workflows/issues/83)) ([3ab0fb1](https://github.com/viamrobotics/claude-ci-workflows/commit/3ab0fb1fd857ae0e1c21c53b9203f84fba922bb7))

## [1.17.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.16.0...v1.17.0) (2026-04-08)


### Features

* comment result on issue/ticket after Claude completes ([#81](https://github.com/viamrobotics/claude-ci-workflows/issues/81)) ([891efc1](https://github.com/viamrobotics/claude-ci-workflows/commit/891efc14c7699d74a581b6dac0ebd72268007785))

## [1.16.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.15.0...v1.16.0) (2026-04-07)


### Features

* Workflow improvements  ([#79](https://github.com/viamrobotics/claude-ci-workflows/issues/79)) ([b5ffe04](https://github.com/viamrobotics/claude-ci-workflows/commit/b5ffe04cd5ef178209e155d743a2f2fa52fab657))

## [1.15.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.14.1...v1.15.0) (2026-03-24)


### Features

* allow on-demand review to push code changes ([#77](https://github.com/viamrobotics/claude-ci-workflows/issues/77)) ([127a3cb](https://github.com/viamrobotics/claude-ci-workflows/commit/127a3cba2c641300413f5283fc9ddfe95f6d422b))

## [1.14.1](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.14.0...v1.14.1) (2026-03-19)


### Bug Fixes

* break review loop between auto-review and pr-fix workflows ([#74](https://github.com/viamrobotics/claude-ci-workflows/issues/74)) ([42d814c](https://github.com/viamrobotics/claude-ci-workflows/commit/42d814c477ce1b95fbcd2423db7f86bd92edd88a))

## [1.14.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.13.0...v1.14.0) (2026-03-12)


### Features

* add reusable workflow for implementing GitHub issues ([#71](https://github.com/viamrobotics/claude-ci-workflows/issues/71)) ([eea0437](https://github.com/viamrobotics/claude-ci-workflows/commit/eea0437f2c654b2dd312e00461cb2ef5c7f43410))

## [1.13.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.12.6...v1.13.0) (2026-03-06)


### Features

* support pull_request_review trigger in pr-fix workflow ([#68](https://github.com/viamrobotics/claude-ci-workflows/issues/68)) ([d1033e7](https://github.com/viamrobotics/claude-ci-workflows/commit/d1033e7e53d4aa38756e262daaa7ef488e26b4d8))

## [1.12.6](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.12.5...v1.12.6) (2026-03-05)


### Bug Fixes

* hardcode main ref for CI prompts checkout ([#66](https://github.com/viamrobotics/claude-ci-workflows/issues/66)) ([88f5049](https://github.com/viamrobotics/claude-ci-workflows/commit/88f504915db89ef0b10be53f138b2d5b1072e8bf))

## [1.12.5](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.12.4...v1.12.5) (2026-03-05)


### Bug Fixes

* pass CI failure logs via artifact in pr-fix to avoid ARG_MAX limit ([#64](https://github.com/viamrobotics/claude-ci-workflows/issues/64)) ([cb2d4c1](https://github.com/viamrobotics/claude-ci-workflows/commit/cb2d4c171f1588419ad8fc5e3fe5ba4852e19c8e))

## [1.12.4](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.12.3...v1.12.4) (2026-03-05)


### Bug Fixes

* pass CI failure logs via artifact to avoid ARG_MAX limit ([#62](https://github.com/viamrobotics/claude-ci-workflows/issues/62)) ([ba8346f](https://github.com/viamrobotics/claude-ci-workflows/commit/ba8346fe97b8ddd2ac077d5ccfc0860ee584e60a))

## [1.12.3](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.12.2...v1.12.3) (2026-03-05)


### Bug Fixes

* upgrade check-pr pull-requests permission to write ([#60](https://github.com/viamrobotics/claude-ci-workflows/issues/60)) ([615b198](https://github.com/viamrobotics/claude-ci-workflows/commit/615b1985deb772d8fbce70fdbcf928e5c3183c4d))

## [1.12.2](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.12.1...v1.12.2) (2026-03-04)


### Bug Fixes

* add pull-requests read permission to check-pr job ([#58](https://github.com/viamrobotics/claude-ci-workflows/issues/58)) ([06d97e1](https://github.com/viamrobotics/claude-ci-workflows/commit/06d97e135ca4dd2e6c4dbf224340b5a495d5886b))

## [1.12.1](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.12.0...v1.12.1) (2026-03-04)


### Bug Fixes

* ensure gh CLI calls run outside caller containers ([#56](https://github.com/viamrobotics/claude-ci-workflows/issues/56)) ([e33e009](https://github.com/viamrobotics/claude-ci-workflows/commit/e33e0098b1d3af09c31b10616e65dbd5ba356474))

## [1.12.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.11.0...v1.12.0) (2026-03-04)


### Features

* add optional container input to all reusable workflows ([#54](https://github.com/viamrobotics/claude-ci-workflows/issues/54)) ([38ef059](https://github.com/viamrobotics/claude-ci-workflows/commit/38ef0590700f9a5eb4d4fcf6b7465d7fc8233e7a))

## [1.11.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.10.7...v1.11.0) (2026-03-04)


### Features

* pass AUTH_TEST_CREDENTIALS secret to claude-code-action ([#52](https://github.com/viamrobotics/claude-ci-workflows/issues/52)) ([d079d8b](https://github.com/viamrobotics/claude-ci-workflows/commit/d079d8bcaa7a8902ad3bbd7e403e38a495919e2f))

## [1.10.7](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.10.6...v1.10.7) (2026-03-04)


### Bug Fixes

* remove language-specific references from dependabot sweep prompts ([#50](https://github.com/viamrobotics/claude-ci-workflows/issues/50)) ([44cc9b8](https://github.com/viamrobotics/claude-ci-workflows/commit/44cc9b8b9149a2fe99d233c6f3dd9916cd9437aa))

## [1.10.6](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.10.5...v1.10.6) (2026-02-28)


### Bug Fixes

* remove redundant prompt instructions in dependabot sweep ([#47](https://github.com/viamrobotics/claude-ci-workflows/issues/47)) ([6796369](https://github.com/viamrobotics/claude-ci-workflows/commit/6796369da6fa020ffdb90d52bba95749a10ee3f3))

## [1.10.5](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.10.4...v1.10.5) (2026-02-26)


### Bug Fixes

* sweep prompt and alert numbers ([#45](https://github.com/viamrobotics/claude-ci-workflows/issues/45)) ([8d2fb3d](https://github.com/viamrobotics/claude-ci-workflows/commit/8d2fb3d18372b07d27f5f94e6eb6eadebda2ce0c))

## [1.10.4](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.10.3...v1.10.4) (2026-02-25)


### Bug Fixes

* open prs ready for review on sweep job ([#43](https://github.com/viamrobotics/claude-ci-workflows/issues/43)) ([a2a9f0d](https://github.com/viamrobotics/claude-ci-workflows/commit/a2a9f0dbe2c3267b967821c3a871daa58b062f10))

## [1.10.3](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.10.2...v1.10.3) (2026-02-25)


### Bug Fixes

* sweep job issues ([#41](https://github.com/viamrobotics/claude-ci-workflows/issues/41)) ([3355824](https://github.com/viamrobotics/claude-ci-workflows/commit/335582412cd146cd6663af8e96ab6285d9f2b3ac))

## [1.10.2](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.10.1...v1.10.2) (2026-02-25)


### Bug Fixes

* use gh api --paginate for Dependabot alerts ([#39](https://github.com/viamrobotics/claude-ci-workflows/issues/39)) ([221cf75](https://github.com/viamrobotics/claude-ci-workflows/commit/221cf751375de8689591528b199886e50d96c3bf))

## [1.10.1](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.10.0...v1.10.1) (2026-02-25)


### Bug Fixes

* show actual API error when Dependabot alerts fetch fails ([#37](https://github.com/viamrobotics/claude-ci-workflows/issues/37)) ([6e616b6](https://github.com/viamrobotics/claude-ci-workflows/commit/6e616b65476369c8966dc436bda87b5366f23fbd))

## [1.10.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.9.0...v1.10.0) (2026-02-25)


### Features

* use GitHub App auth for dependabot sweep workflow ([#35](https://github.com/viamrobotics/claude-ci-workflows/issues/35)) ([c7fe288](https://github.com/viamrobotics/claude-ci-workflows/commit/c7fe288fb59f44eb95e703d8a3eb5206bc346dda))

## [1.9.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.8.0...v1.9.0) (2026-02-25)


### Features

* add Dependabot sweep workflow ([#33](https://github.com/viamrobotics/claude-ci-workflows/issues/33)) ([c2267eb](https://github.com/viamrobotics/claude-ci-workflows/commit/c2267ebb7c3508ff9d11b06bcd7fd0304f218f88))

## [1.8.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.7.0...v1.8.0) (2026-02-25)


### Features

* claude pr fix workflow ([#31](https://github.com/viamrobotics/claude-ci-workflows/issues/31)) ([27fa508](https://github.com/viamrobotics/claude-ci-workflows/commit/27fa5084cd2b6556d6f011e72ad32c67c72236d7))

## [1.7.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.6.1...v1.7.0) (2026-02-25)


### Features

* Improve ci common ([#29](https://github.com/viamrobotics/claude-ci-workflows/issues/29)) ([2db26b9](https://github.com/viamrobotics/claude-ci-workflows/commit/2db26b9d2ceabb1f0322d5799ef24fdf3913ddd1))

## [1.6.1](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.6.0...v1.6.1) (2026-02-24)


### Bug Fixes

* prevent wasted CI turns on git commits and Edit-without-Read ([#27](https://github.com/viamrobotics/claude-ci-workflows/issues/27)) ([e8b6a45](https://github.com/viamrobotics/claude-ci-workflows/commit/e8b6a45fa47928e5b0fcbb17adb7498fcfb3a40b))

## [1.6.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.5.2...v1.6.0) (2026-02-24)


### Features

* move to gh token generation ([#25](https://github.com/viamrobotics/claude-ci-workflows/issues/25)) ([0f2cb57](https://github.com/viamrobotics/claude-ci-workflows/commit/0f2cb57b6d6bf8b268716dfcb1cee14b8eee675e))

## [1.5.2](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.5.1...v1.5.2) (2026-02-24)


### Bug Fixes

* docs ([#23](https://github.com/viamrobotics/claude-ci-workflows/issues/23)) ([b4b00c2](https://github.com/viamrobotics/claude-ci-workflows/commit/b4b00c2e6f1a23272a0c12d4136020c0f374bda5))

## [1.5.1](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.5.0...v1.5.1) (2026-02-24)


### Bug Fixes

* move system prompt to env ([#20](https://github.com/viamrobotics/claude-ci-workflows/issues/20)) ([5e29706](https://github.com/viamrobotics/claude-ci-workflows/commit/5e29706c9e44186bb75535f0443a443c9b4eee5c))

## [1.5.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.4.1...v1.5.0) (2026-02-24)


### Features

* add input to turn on debug ([#18](https://github.com/viamrobotics/claude-ci-workflows/issues/18)) ([5c9190b](https://github.com/viamrobotics/claude-ci-workflows/commit/5c9190b7d7a8da88647fb0bf617a51bac79ff6e3))

## [1.4.1](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.4.0...v1.4.1) (2026-02-24)


### Bug Fixes

* fix workflow sha ([#16](https://github.com/viamrobotics/claude-ci-workflows/issues/16)) ([a8c2f4e](https://github.com/viamrobotics/claude-ci-workflows/commit/a8c2f4e1f8216cb97fc883504cc7cd956c6c430d))

## [1.4.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.3.0...v1.4.0) (2026-02-23)


### Features

* Consolidate CI related claude instructions ([#14](https://github.com/viamrobotics/claude-ci-workflows/issues/14)) ([72bb473](https://github.com/viamrobotics/claude-ci-workflows/commit/72bb473895208bb0972fff6b13fdafcfe4965dca))

## [1.3.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.2.0...v1.3.0) (2026-02-23)


### Features

* add responsible engineer ([#11](https://github.com/viamrobotics/claude-ci-workflows/issues/11)) ([b8b2c08](https://github.com/viamrobotics/claude-ci-workflows/commit/b8b2c08f11102bcde21df4b343811933330aefd1))

## [1.2.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.1.0...v1.2.0) (2026-02-23)


### Features

* add task_complexity input to jira workflow ([#9](https://github.com/viamrobotics/claude-ci-workflows/issues/9)) ([ab2e348](https://github.com/viamrobotics/claude-ci-workflows/commit/ab2e3482da410fa013c7905bb74c9a567ab12d5c))

## [1.1.0](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.0.1...v1.1.0) (2026-02-21)


### Features

* allow to append to the system prompt ([#7](https://github.com/viamrobotics/claude-ci-workflows/issues/7)) ([422cab1](https://github.com/viamrobotics/claude-ci-workflows/commit/422cab195dc4cab9e98a8f97098d97727ba950d6))

## [1.0.1](https://github.com/viamrobotics/claude-ci-workflows/compare/v1.0.0...v1.0.1) (2026-02-21)


### Bug Fixes

* Be explicit about inline review behavior ([#5](https://github.com/viamrobotics/claude-ci-workflows/issues/5)) ([84bbc6f](https://github.com/viamrobotics/claude-ci-workflows/commit/84bbc6fd9ed0bfd5da53b3a8edb88dadd4a2bb94))

## 1.0.0 (2026-02-20)


### Features

* Add reusable claude workflows ([#1](https://github.com/viamrobotics/claude-ci-workflows/issues/1)) ([1054477](https://github.com/viamrobotics/claude-ci-workflows/commit/10544771aac5140a3e496084e823d2c638dc6c87))

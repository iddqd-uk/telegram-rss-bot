# Telegram RSS bot

[![Tests Status][badge_tests]][link_actions]
[![Deploy Status][badge_deploy]][link_deploy]

Telegram RSS bot for updating notifications.

## Environment

For environment values management, you can use the Consul KV. This is very simple, your variables will be automatically passed to the container with the application _(containers will be restarted automatically)_. KV namespace is `apps/bots/telegram-rss/environment`.

> For example, if you create a key `apps/bots/telegram-rss/environment/NO_PROXY` with a value `true` - the environment variable `NO_PROXY` will be available inside the container with a value `true`.

### Links

- [Docker image page](https://github.com/tarampampam/rssbot-docker)
- [Project page](https://github.com/iovxw/rssbot)

[badge_tests]:https://img.shields.io/github/workflow/status/iddqd-uk/telegram-rss-bot/tests/main?logo=github&logoColor=white&label=tests
[badge_deploy]:https://img.shields.io/github/workflow/status/iddqd-uk/telegram-rss-bot/deploy/main?logo=github&logoColor=white&label=deploy
[link_actions]:https://github.com/iddqd-uk/telegram-rss-bot/actions
[link_deploy]:https://github.com/iddqd-uk/telegram-rss-bot/actions/workflows/deploy.yml

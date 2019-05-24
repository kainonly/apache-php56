## NGINX 基本防护

修改 `nginx.conf`

```conf
server {
    #禁止Scrapy等爬虫工具的抓取
    if ($http_user_agent ~* "Scrapy|Sogou web spider|Baiduspider") {
        return 403;
    }

    #禁止指定UA及UA为空的访问
    if ($http_user_agent ~ "FeedDemon|JikeSpider|Indy Library|Alexa Toolbar|AskTbFXTV|AhrefsBot|CrawlDaddy|CoolpadWebkit|Java|Feedly|UniversalFeedParser|ApacheBench|Microsoft URL Control|Swiftbot|ZmEu|oBot|jaunty|Python-urllib|lightDeckReports Bot|YYSpider|DigExt|YisouSpider|HttpClient|MJ12bot|heritrix|EasouSpider|LinkpadBot|Ezooms|^$" ) {
        return 403;
    }

    #禁止非GET|HEAD|POST方式的抓取
    if ($request_method !~ ^(GET|HEAD|POST)$) {
        return 403;
    }
}
```
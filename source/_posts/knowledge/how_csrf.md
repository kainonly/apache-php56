---
title: 如何防止CSRF攻击？
categories: 涨知识
---

随着互联网的高速发展，信息安全问题已经成为企业最为关注的焦点之一，而前端又是引发企业安全问题的高危据点。在移动互联网时代，前端人员除了传统的 XSS、CSRF 等安全问题之外，又时常遭遇网络劫持、非法调用 Hybrid API 等新型安全问题。当然，浏览器自身也在不断在进化和发展，不断引入 CSP、Same-Site Cookies 等新技术来增强安全性，但是仍存在很多潜在的威胁，这需要前端技术人员不断进行“查漏补缺”。

作者：美团技术团队
链接：https://juejin.cn/post/6844903689702866952

<!-- more -->

## 前端安全

近几年，美团业务高速发展，前端随之面临很多安全挑战，因此积累了大量的实践经验。我们梳理了常见的前端安全问题以及对应的解决方案，将会做成一个系列，希望可以帮助前端同学在日常开发中不断预防和修复安全漏洞。本文是该系列的第二篇。

今天我们讲解一下 CSRF，其实相比 XSS，CSRF 的名气似乎并不是那么大，很多人都认为“CSRF 不具备那么大的破坏性”。真的是这样吗？接下来，我们还是有请小明同学再次“闪亮”登场。

## CSRF 攻击

### CSRF 漏洞的发生

相比 XSS，CSRF 的名气似乎并不是那么大，很多人都认为 CSRF“不那么有破坏性”。真的是这样吗？

接下来有请小明出场~~

### 小明的悲惨遭遇

这一天，小明同学百无聊赖地刷着 Gmail 邮件。大部分都是没营养的通知、验证码、聊天记录之类。但有一封邮件引起了小明的注意：

> 甩卖比特币，一个只要 998！！

聪明的小明当然知道这种肯定是骗子，但还是抱着好奇的态度点了进去（请勿模仿）。果然，这只是一个什么都没有的空白页面，小明失望的关闭了页面。一切似乎什么都没有发生......

在这平静的外表之下，黑客的攻击已然得手。小明的 Gmail 中，被偷偷设置了一个过滤规则，这个规则使得所有的邮件都会被自动转发到haker@hackermail.com。小明还在继续刷着邮件，殊不知他的邮件正在一封封地，如脱缰的野马一般地，持续不断地向着黑客的邮箱转发而去。

不久之后的一天，小明发现自己的域名已经被转让了。懵懂的小明以为是域名到期自己忘了续费，直到有一天，对方开出了 $650 的赎回价码，小明才开始觉得不太对劲。

小明仔细查了下域名的转让，对方是拥有自己的验证码的，而域名的验证码只存在于自己的邮箱里面。小明回想起那天奇怪的链接，打开后重新查看了“空白页”的源码：

```html
<form
  method="POST"
  action="https://mail.google.com/mail/h/ewt1jmuj4ddv/?v=prf"
  enctype="multipart/form-data"
>
  <input type="hidden" name="cf2_emc" value="true" />
  <input type="hidden" name="cf2_email" value="hacker@hakermail.com" />
  .....
  <input type="hidden" name="irf" value="on" />
  <input type="hidden" name="nvp_bu_cftb" value="Create Filter" />
</form>
<script>
  document.forms[0].submit();
</script>
```

> 这个页面只要打开，就会向 Gmail 发送一个 post 请求。请求中，执行了“Create Filter”命令，将所有的邮件，转发到“hacker@hakermail.com”。

> 小明由于刚刚就登陆了 Gmail，所以这个请求发送时，携带着小明的登录凭证（Cookie），Gmail 的后台接收到请求，验证了确实有小明的登录凭证，于是成功给小明配置了过滤器。

> 黑客可以查看小明的所有邮件，包括邮件里的域名验证码等隐私信息。拿到验证码之后，黑客就可以要求域名服务商把域名重置给自己。

小明很快打开 Gmail，找到了那条过滤器，将其删除。然而，已经泄露的邮件，已经被转让的域名，再也无法挽回了......

以上就是小明的悲惨遭遇。而“点开一个黑客的链接，所有邮件都被窃取”这种事情并不是杜撰的，此事件原型是 2007 年 Gmail 的 CSRF 漏洞：

[www.davidairey.com/google-Gmai…](https://www.davidairey.com/google-gmail-security-hijack/)

当然，目前此漏洞已被 Gmail 修复，请使用 Gmail 的同学不要慌张。

### 什么是 CSRF

CSRF（Cross-site request forgery）跨站请求伪造：攻击者诱导受害者进入第三方网站，在第三方网站中，向被攻击网站发送跨站请求。利用受害者在被攻击网站已经获取的注册凭证，绕过后台的用户验证，达到冒充用户对被攻击的网站执行某项操作的目的。

一个典型的 CSRF 攻击有着如下的流程：

- 受害者登录 a.com，并保留了登录凭证（Cookie）。
- 攻击者引诱受害者访问了 b.com。
- b.com 向 a.com 发送了一个请求：a.com/act=xx。浏览器会…
- a.com 接收到请求后，对请求进行验证，并确认是受害者的凭证，误以为是受害者自己发送的请求。
- a.com 以受害者的名义执行了 act=xx。
- 攻击完成，攻击者在受害者不知情的情况下，冒充受害者，让 a.com 执行了自己定义的操作。

### 几种常见的攻击类型

- GET 类型的 CSRF

GET 类型的 CSRF 利用非常简单，只需要一个 HTTP 请求，一般会这样利用：

```html
<img src="http://bank.example/withdraw?amount=10000&for=hacker" />
```

在受害者访问含有这个 img 的页面后，浏览器会自动向 `http://bank.example/withdraw?account=xiaoming&amount=10000&for=hacker` 发出一次 HTTP 请求。bank.example 就会收到包含受害者登录信息的一次跨域请求。

- POST 类型的 CSRF

这种类型的 CSRF 利用起来通常使用的是一个自动提交的表单，如：

```html
<form action="http://bank.example/withdraw" method="POST">
  <input type="hidden" name="account" value="xiaoming" />
  <input type="hidden" name="amount" value="10000" />
  <input type="hidden" name="for" value="hacker" />
</form>
<script>
  document.forms[0].submit();
</script>
```

访问该页面后，表单会自动提交，相当于模拟用户完成了一次 POST 操作。

POST 类型的攻击通常比 GET 要求更加严格一点，但仍并不复杂。任何个人网站、博客，被黑客上传页面的网站都有可能是发起攻击的来源，后端接口不能将安全寄托在仅允许 POST 上面。

- 链接类型的 CSRF

链接类型的 CSRF 并不常见，比起其他两种用户打开页面就中招的情况，这种需要用户点击链接才会触发。这种类型通常是在论坛中发布的图片中嵌入恶意链接，或者以广告的形式诱导用户中招，攻击者通常会以比较夸张的词语诱骗用户点击，例如：

```html
<a
  href="http://test.com/csrf/withdraw.php?amount=1000&for=hacker"
  taget="_blank"
>
  重磅消息！！
  <a
/></a>
```

由于之前用户登录了信任的网站 A，并且保存登录状态，只要用户主动访问上面的这个 PHP 页面，则表示攻击成功。

### CSRF 的特点

- 攻击一般发起在第三方网站，而不是被攻击的网站。被攻击的网站无法防止攻击发生。
- 攻击利用受害者在被攻击网站的登录凭证，冒充受害者提交操作；而不是直接窃取数据。
- 整个过程攻击者并不能获取到受害者的登录凭证，仅仅是“冒用”。
- 跨站请求可以用各种方式：图片 URL、超链接、CORS、Form 提交等等。部分请求方式可以直接嵌入在第三方论坛、文章中，难以进行追踪。

CSRF 通常是跨域的，因为外域通常更容易被攻击者掌控。但是如果本域下有容易被利用的功能，比如可以发图和链接的论坛和评论区，攻击可以直接在本域下进行，而且这种攻击更加危险。

### 防护策略

CSRF 通常从第三方网站发起，被攻击的网站无法防止攻击发生，只能通过增强自己网站针对 CSRF 的防护能力来提升安全性。

上文中讲了 CSRF 的两个特点：

- CSRF（通常）发生在第三方域名。
- CSRF 攻击者不能获取到 Cookie 等信息，只是使用。

针对这两点，我们可以专门制定防护策略，如下：

- 阻止不明外域的访问
  - 同源检测
  - Samesite Cookie
- 提交时要求附加本域才能获取的信息
  - CSRF Token
  - 双重 Cookie 验证

以下我们对各种防护方法做详细说明：

#### 同源检测

既然 CSRF 大多来自第三方网站，那么我们就直接禁止外域（或者不受信任的域名）对我们发起请求。

那么问题来了，我们如何判断请求是否来自外域呢？

在 HTTP 协议中，每一个异步请求都会携带两个 Header，用于标记来源域名：

- Origin Header
- Referer Header

这两个 Header 在浏览器发起请求时，大多数情况会自动带上，并且不能由前端自定义内容。 服务器可以通过解析这两个 Header 中的域名，确定请求的来源域。

##### 使用 Origin Header 确定来源域名

在部分与 CSRF 有关的请求中，请求的 Header 中会携带 Origin 字段。字段内包含请求的域名（不包含 path 及 query）。

如果 Origin 存在，那么直接使用 Origin 中的字段确认来源域名就可以。

但是 Origin 在以下两种情况下并不存在：

- **IE11 同源策略：** IE 11 不会在跨站 CORS 请求上添加 Origin 标头，Referer 头将仍然是唯一的标识。最根本原因是因为 IE 11 对同源的定义和其他浏览器有不同，有两个主要的区别，可以参考[MDN Same-origin_policy#IE_Exceptions](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy#IE_Exceptions)
- **302 重定向：** 在 302 重定向之后 Origin 不包含在重定向的请求中，因为 Origin 可能会被认为是其他来源的敏感信息。对于 302 重定向的情况来说都是定向到新的服务器上的 URL，因此浏览器不想将 Origin 泄漏到新的服务器上。

##### 使用 Referer Header 确定来源域名

根据 HTTP 协议，在 HTTP 头中有一个字段叫 Referer，记录了该 HTTP 请求的来源地址。
对于 Ajax 请求，图片和 script 等资源请求，Referer 为发起请求的页面地址。对于页面跳转，Referer 为打开页面历史记录的前一个页面地址。因此我们使用 Referer 中链接的 Origin 部分可以得知请求的来源域名。

这种方法并非万无一失，Referer 的值是由浏览器提供的，虽然 HTTP 协议上有明确的要求，但是每个浏览器对于 Referer 的具体实现可能有差别，并不能保证浏览器自身没有安全漏洞。使用验证 Referer 值的方法，就是把安全性都依赖于第三方（即浏览器）来保障，从理论上来讲，这样并不是很安全。在部分情况下，攻击者可以隐藏，甚至修改自己请求的 Referer。

2014 年，W3C 的 Web 应用安全工作组发布了 Referrer Policy 草案，对浏览器该如何发送 Referer 做了详细的规定。截止现在新版浏览器大部分已经支持了这份草案，我们终于可以灵活地控制自己网站的 Referer 策略了。新版的 Referrer Policy 规定了五种 Referer 策略：No Referrer、No Referrer When Downgrade、Origin Only、Origin When Cross-origin、和 Unsafe URL。之前就存在的三种策略：never、default 和 always，在新标准里换了个名称。他们的对应关系如下：

| 策略名称                   | 属性值（新）                     | 属性值（旧） |
| -------------------------- | -------------------------------- | ------------ |
| No Referrer                | no-Referrer                      | never        |
| No Referrer When Downgrade | no-Referrer-when-downgrade       | default      |
| Origin Only                | (same or strict) origin          | origin       |
| Origin When Cross Origin   | (strict) origin-when-crossorigin | -            |
| Unsafe URL                 | unsafe-url                       | always       |

根据上面的表格因此需要把 Referrer Policy 的策略设置成 same-origin，对于同源的链接和引用，会发送 Referer，referer 值为 Host 不带 Path；跨域访问则不携带 Referer。例如：aaa.com 引用 bbb.com 的资源，不会发送 Referer。

设置 Referrer Policy 的方法有三种：

1. 在 CSP 设置
2. 页面头部增加 meta 标签
3. a 标签增加 referrerpolicy 属性

上面说的这些比较多，但我们可以知道一个问题：攻击者可以在自己的请求中隐藏 Referer。如果攻击者将自己的请求这样填写：

```html
<img
  src="http://bank.example/withdraw?amount=10000&for=hacker"
  referrerpolicy="no-referrer"
/>
```

那么这个请求发起的攻击将不携带 Referer。

另外在以下情况下 Referer 没有或者不可信：

1. IE6、7 下使用 window.location.href=url 进行界面的跳转，会丢失 Referer。
2. IE6、7 下使用 window.open，也会缺失 Referer。
3. HTTPS 页面跳转到 HTTP 页面，所有浏览器 Referer 都丢失。
4. 点击 Flash 上到达另外一个网站的时候，Referer 的情况就比较杂乱，不太可信。

##### 无法确认来源域名情况

当 Origin 和 Referer 头文件不存在时该怎么办？如果 Origin 和 Referer 都不存在，建议直接进行阻止，特别是如果您没有使用随机 CSRF Token（参考下方）作为第二次检查。

##### 如何阻止外域请求

通过 Header 的验证，我们可以知道发起请求的来源域名，这些来源域名可能是网站本域，或者子域名，或者有授权的第三方域名，又或者来自不可信的未知域名。

我们已经知道了请求域名是否是来自不可信的域名，我们直接阻止掉这些的请求，就能防御 CSRF 攻击了吗？

且慢！当一个请求是页面请求（比如网站的主页），而来源是搜索引擎的链接（例如百度的搜索结果），也会被当成疑似 CSRF 攻击。所以在判断的时候需要过滤掉页面请求情况，通常 Header 符合以下情况：

```http
Accept: text/html
Method: GET
```

但相应的，页面请求就暴露在了 CSRF 的攻击范围之中。如果你的网站中，在页面的 GET 请求中对当前用户做了什么操作的话，防范就失效了。

例如，下面的页面请求：

```http
GET https://example.com/addComment?comment=XXX&dest=orderId
```

注：这种严格来说并不一定存在 CSRF 攻击的风险，但仍然有很多网站经常把主文档 GET 请求挂上参数来实现产品功能，但是这样做对于自身来说是存在安全风险的。
另外，前面说过，CSRF 大多数情况下来自第三方域名，但并不能排除本域发起。如果攻击者有权限在本域发布评论（含链接、图片等，统称 UGC），那么它可以直接在本域发起攻击，这种情况下同源策略无法达到防护的作用。
综上所述：同源验证是一个相对简单的防范方法，能够防范绝大多数的 CSRF 攻击。但这并不是万无一失的，对于安全性要求较高，或者有较多用户输入内容的网站，我们就要对关键的接口做额外的防护措施。

#### CSRF Token

前面讲到 CSRF 的另一个特征是，攻击者无法直接窃取到用户的信息（Cookie，Header，网站内容等），仅仅是冒用 Cookie 中的信息。

而 CSRF 攻击之所以能够成功，是因为服务器误把攻击者发送的请求当成了用户自己的请求。那么我们可以要求所有的用户请求都携带一个 CSRF 攻击者无法获取到的 Token。服务器通过校验请求是否携带正确的 Token，来把正常的请求和攻击的请求区分开，也可以防范 CSRF 的攻击。

##### 原理

CSRF Token 的防护策略分为三个步骤：

1. 将 CSRF Token 输出到页面中

首先，用户打开页面的时候，服务器需要给这个用户生成一个 Token，该 Token 通过加密算法对数据进行加密，一般 Token 都包括随机字符串和时间戳的组合，显然在提交时 Token 不能再放在 Cookie 中了，否则又会被攻击者冒用。因此，为了安全起见 Token 最好还是存在服务器的 Session 中，之后在每次页面加载时，使用 JS 遍历整个 DOM 树，对于 DOM 中所有的 a 和 form 标签后加入 Token。这样可以解决大部分的请求，但是对于在页面加载之后动态生成的 HTML 代码，这种方法就没有作用，还需要程序员在编码时手动添加 Token。

2. 页面提交的请求携带这个 Token

对于 GET 请求，Token 将附在请求地址之后，这样 URL 就变成 http://url?csrftoken=tokenvalue。 而对于 POST 请求来说，要在 form 的最后加上：

```html
<input type="”hidden”" name="”csrftoken”" value="”tokenvalue”" />
```

这样，就把 Token 以参数的形式加入请求了。

3. 服务器验证 Token 是否正确

当用户从客户端得到了 Token，再次提交给服务器的时候，服务器需要判断 Token 的有效性，验证过程是先解密 Token，对比加密字符串以及时间戳，如果加密字符串一致且时间未过期，那么这个 Token 就是有效的。
这种方法要比之前检查 Referer 或者 Origin 要安全一些，Token 可以在产生并放于 Session 之中，然后在每次请求时把 Token 从 Session 中拿出，与请求中的 Token 进行比对，但这种方法的比较麻烦的在于如何把 Token 以参数的形式加入请求。

下面将以 Java 为例，介绍一些 CSRF Token 的服务端校验逻辑，代码如下：

```java
HttpServletRequest req = (HttpServletRequest)request;
HttpSession s = req.getSession();

// 从 session 中得到 csrftoken 属性
String sToken = (String)s.getAttribute("csrftoken");
if(sToken == null){
   // 产生新的 token 放入 session 中
   sToken = generateToken();
   s.setAttribute("csrftoken",sToken);
   chain.doFilter(request, response);
} else{
   // 从 HTTP 头中取得 csrftoken
   String xhrToken = req.getHeader("csrftoken");
   // 从请求参数中取得 csrftoken
   String pToken = req.getParameter("csrftoken");
   if(sToken != null && xhrToken != null && sToken.equals(xhrToken)){
       chain.doFilter(request, response);
   }else if(sToken != null && pToken != null && sToken.equals(pToken)){
       chain.doFilter(request, response);
   }else{
       request.getRequestDispatcher("error.jsp").forward(request,response);
   }
}
```

代码源自[IBM developerworks CSRF](https://www.ibm.com/developerworks/cn/web/1102_niugang_csrf/)

这个 Token 的值必须是随机生成的，这样它就不会被攻击者猜到，考虑利用 Java 应用程序的 java.security.SecureRandom 类来生成足够长的随机标记，替代生成算法包括使用 256 位 BASE64 编码哈希，选择这种生成算法的开发人员必须确保在散列数据中使用随机性和唯一性来生成随机标识。通常，开发人员只需为当前会话生成一次 Token。在初始生成此 Token 之后，该值将存储在会话中，并用于每个后续请求，直到会话过期。当最终用户发出请求时，服务器端必须验证请求中 Token 的存在性和有效性，与会话中找到的 Token 相比较。如果在请求中找不到 Token，或者提供的值与会话中的值不匹配，则应中止请求，应重置 Token 并将事件记录为正在进行的潜在 CSRF 攻击。

#### 分布式校验

在大型网站中，使用 Session 存储 CSRF Token 会带来很大的压力。访问单台服务器 session 是同一个。但是现在的大型网站中，我们的服务器通常不止一台，可能是几十台甚至几百台之多，甚至多个机房都可能在不同的省份，用户发起的 HTTP 请求通常要经过像 Ngnix 之类的负载均衡器之后，再路由到具体的服务器上，由于 Session 默认存储在单机服务器内存中，因此在分布式环境下同一个用户发送的多次 HTTP 请求可能会先后落到不同的服务器上，导致后面发起的 HTTP 请求无法拿到之前的 HTTP 请求存储在服务器中的 Session 数据，从而使得 Session 机制在分布式环境下失效，因此在分布式集群中 CSRF Token 需要存储在 Redis 之类的公共存储空间。

由于使用 Session 存储，读取和验证 CSRF Token 会引起比较大的复杂度和性能问题，目前很多网站采用 Encrypted Token Pattern 方式。这种方法的 Token 是一个计算出来的结果，而非随机生成的字符串。这样在校验时无需再去读取存储的 Token，只用再次计算一次即可。

这种 Token 的值通常是使用 UserID、时间戳和随机数，通过加密的方法生成。这样既可以保证分布式服务的 Token 一致，又能保证 Token 不容易被破解。

在 token 解密成功之后，服务器可以访问解析值，Token 中包含的 UserID 和时间戳将会被拿来被验证有效性，将 UserID 与当前登录的 UserID 进行比较，并将时间戳与当前时间进行比较。

##### 总结

Token 是一个比较有效的 CSRF 防护方法，只要页面没有 XSS 漏洞泄露 Token，那么接口的 CSRF 攻击就无法成功。
但是此方法的实现比较复杂，需要给每一个页面都写入 Token（前端无法使用纯静态页面），每一个 Form 及 Ajax 请求都携带这个 Token，后端对每一个接口都进行校验，并保证页面 Token 及请求 Token 一致。这就使得这个防护策略不能在通用的拦截上统一拦截处理，而需要每一个页面和接口都添加对应的输出和校验。这种方法工作量巨大，且有可能遗漏。

> 验证码和密码其实也可以起到 CSRF Token 的作用哦，而且更安全。

> 为什么很多银行等网站会要求已经登录的用户在转账时再次输入密码，现在是不是有一定道理了？

#### 双重 Cookie 验证

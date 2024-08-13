# Jwt

## 密钥的类型

密钥通常是一个字符串，通常是用作 HMAC（例如 HS256、HS384、HS512）算法的密钥。这个密钥可以是任何字符串，但为了确保安全性，通常会选择一个随机生成的、足够复杂的字符串。

## 密钥的长度

密钥的长度要求取决于你所使用的加密算法：

* **HS256** : 建议至少使用 32 字节（256 位）长度的密钥。
* **HS384** : 建议至少使用 48 字节（384 位）长度的密钥。
* **HS512** : 建议至少使用 64 字节（512 位）长度的密钥。

短于这些推荐长度的密钥虽然可以使用，但会降低安全性，增加被破解的风险。

## 示例代码

创建TOKEN

```C#
 private string CreateToken(User user)
 {
     List<Claim> claims = new List<Claim>
     {
         new Claim(ClaimTypes.NameIdentifier, user.Id),
         new Claim(ClaimTypes.Name, user.Account),
         new Claim(ClaimTypes.Role, user.Role)
     };
     var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8
         .GetBytes(_authSettingsOpt.Value.SecurityKey));

    // var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature); //这个需要更长的密钥，同时要牺牲一点性能
     var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

     var token = new JwtSecurityToken(
             claims: claims,
             expires: DateTime.Now.AddDays(_authSettingsOpt.Value.ExpireDays),
             //expires: DateTime.Now.AddSeconds(5),
             signingCredentials: creds);

     var jwt = new JwtSecurityTokenHandler().WriteToken(token);

     return jwt;
 }
```

## 总结

* 密钥应该是一个随机生成的、复杂的字符串。
* 密钥的长度应根据所使用的算法来确定，建议至少达到算法要求的位数，以确保安全性。

使用强密码生成器或专门的密钥管理工具来生成和存储这些密钥，可以进一步提升安全性。

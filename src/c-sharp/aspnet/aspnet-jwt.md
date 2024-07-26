# Jwt

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

 **SigningCredentials(key, SecurityAlgorithms.HmacSha256)**

 不同的`SecurityAlgorithms` 对 `key`的长度要求不同，否则在 执行 `new JwtSecurityTokenHandler().WriteToken(token)` 会有异常，如果使用的512那么就要使用更长的密钥，具体多长，要自己试一下。


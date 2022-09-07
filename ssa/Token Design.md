Token Design
===

## 分类

### 接口令牌 API Token

生成 Token

```javascript
/**
 * 生成token
 * @param $user_info string 
 * @param $app_key string  app_key
 * @param $app_id int app_id
 * @return string
 */
public function generate_access_token($user_info , $app_key, $app_id)
{
    $time = time();
    $sign = sha1($time . $advertiser_id . $app_key);
    $token = base64_encode("{$time},{$user_info },{$app_id},{$sign}";// 分隔符建议替换成其他的字符
    return $token;
}
```

解密 Token

```javascript
/**
 * 解析token
 * @param $access_token
 * @return array
 */
public function analysis_access_token($access_token)
{
    $token_array = base64_decode($access_token);
    $token_array = explode(',', $token_array);// 分隔符由Token生成法决定
    $time = $token_array[0];
    $user_info = $token_array[1];
    $app_id = $token_array[2];// 暴露在外的公钥
    $sign = $token_array[3];
    if ($time < (time() - 60) || $time > (time() + 60)) { // 校验时可以自定义
        call_back(1101, 'Access Token expire !token='.$access_token);
    }
    global $third_platform_app_key;// app_id-app_key对应表
    if (!isset($third_platform_app_key[$app_id])) {
        call_back(1101, 'Access Token App id Error!token=' .$access_token);
    }
    $app_key = $third_platform_app_key[$app_id];
    $local_sign = sha1($time . $user_info . $app_key);// 利用私钥进签名，验证有效性
    if ($local_sign === $sign) {
        return [
            'access_token' => $access_token,
            'user_info' => $user_info,
            'time' => $time,
            'app_id' => $app_id,
            'app_key' => $app_key,
        ];
    } else {
        call_back(1101, 'Access Token Sign Error!token=' .$access_token);
    }
}
```


```java
public static String signTopRequest(Map<String, String> params, String secret, String signMethod) throws IOException {
	// 第一步：检查参数是否已经排序
	String[] keys = params.keySet().toArray(new String[0]);
	Arrays.sort(keys);

	// 第二步：把所有参数名和参数值串在一起
	StringBuilder query = new StringBuilder();
	if (Constants.SIGN_METHOD_MD5.equals(signMethod)) { //签名的摘要算法，可选值为：hmac，md5，hmac-sha256
		query.append(secret);
	}
	for (String key : keys) {
		String value = params.get(key);
		if (StringUtils.areNotEmpty(key, value)) {
			query.append(key).append(value);
		}
	}

	// 第三步：使用MD5/HMAC加密
	byte[] bytes;
	if (Constants.SIGN_METHOD_HMAC.equals(signMethod)) {
		bytes = encryptHMAC(query.toString(), secret);
	} else {
		query.append(secret);
		bytes = encryptMD5(query.toString());
	}

	// 第四步：把二进制转化为大写的十六进制(正确签名应该为32大写字符串，此方法需要时使用)
	//return byte2hex(bytes);
}

public static byte[] encryptHMAC(String data, String secret) throws IOException {
	byte[] bytes = null;
	try {
		SecretKey secretKey = new SecretKeySpec(secret.getBytes(Constants.CHARSET_UTF8), "HmacMD5");
		Mac mac = Mac.getInstance(secretKey.getAlgorithm());
		mac.init(secretKey);
		bytes = mac.doFinal(data.getBytes(Constants.CHARSET_UTF8));
	} catch (GeneralSecurityException gse) {
		throw new IOException(gse.toString());
	}
	return bytes;
}

public static byte[] encryptMD5(String data) throws IOException {
	return encryptMD5(data.getBytes(Constants.CHARSET_UTF8));
}

public static String byte2hex(byte[] bytes) {
	StringBuilder sign = new StringBuilder();
	for (int i = 0; i < bytes.length; i++) {
		String hex = Integer.toHexString(bytes[i] & 0xFF);
		if (hex.length() == 1) {
			sign.append("0");
		}
		sign.append(hex.toUpperCase());
	}
	return sign.toString();
}
```

### 用户令牌 User Token

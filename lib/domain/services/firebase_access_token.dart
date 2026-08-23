import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';

class FirebaseAccessToken {
  static const String firebaseMsgScope =
      "https://www.googleapis.com/auth/firebase.messaging";

  Future<String> getToken() async {
    final credentials = ServiceAccountCredentials.fromJson({
      "type": "service_account",
      "project_id": "co-chat-36393",
      "private_key_id": "7cc7a0c25ff7711342ee4648680cfbcecc5013a1",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQCv6/r50eo4bIXL\n9k0NIVNnZ0QKxxyRuIVcqk62fOsVaMiysq18MYNRXtTebYcOP/K6EzwTfrQna7n7\nRHcLpMz7yvWV/nMR+MCZlziahegTwmziT811fg/DlGZp/gphOwq6pkb6IoW6bcLo\nhWYUtLVYHTIPedwKU7hoVTE2s3vrif20lunnHWdETXI0TVfDeqF/Fx5kVMfFVJPn\nyN0TXDryyxPsX6+HlyDjhWM4ZHt8OxwgwukfkEtOpwD9rbjzLBjp+XE+HBAAGNLb\nj5KH8JoDo091BRDyK+yZBoxQk4U5xJTAU1J89V1Y7n5SvNzZXuQ7g7+VDPU9Sh8a\noVIG+AV5AgMBAAECggEAAQfMpDSDsCI66LZdg0D7/TMH7Ao9YkFJGNnlw5kKG6JD\n/rDlA6O4TMZLxq46GZCdVBjaq1kt/wwKTUVylnOae6Arc94f4loajI46tTo84TJK\nAfzlcwHaERhAyNw7qbdyZYbNHz9t0/MAGtnhL9l6XMOnUtZsAx3ICrVVWW0tfOpv\neD2yLGQyxe+yktVWnCiMmxmJt8BV7HQKbLSTTlHebFJQGaNz0YSgH2+aurEmmet1\npTvh6b6pM1kvVmBge+mjK05il5dH4fHQ4bfMti49Qs/VBJHeQprUvOzWYAptvKOY\n233Zc/XayUf3KRZNAub5VT1mVi/dTIVWAVu/QpxhyQKBgQDsNYye4HsQEI3NAXk6\nTceIJopjRtwnesvwQWe+hWYnrZTnVa1KMiweCtz0sLtFeWx9RiUWFIApqXfcrKaM\nefmDQJYzVwqLPOE8sbSO1zx4zSL1gIscPm+7W7ZMfqV0pzYv7Xqngq4TfXq1TX86\nY0uzo5fbyyIFUjqyiLB6O9eClQKBgQC+qVO7LkuxKkCgTf9/zJgK/F/3ofz8M/yT\ndJHLCQKITotUMnPDxC5VukrOaZP7xFZpqGCusOjfv1hjreMt0bul71jLKohKNcku\nmNG5p8+CnkqAAZT5isO8PRv7a0/blp3p6DO7cVcGuI5YT35100RAvOFFgP4Unv+v\nGf4tmzKCVQKBgQDMQCnOoFIJvCbB5MpNDkDBjIISAo4QXXDH2ea5qmSBXunpd/6W\nr/fSKpaRx9jH5I1ZbjRXeXaxj+cjnO+PfVGym0DGODfX2tbxQsDc22VhGBFotLSV\nwa+gFVf3oXO1AXory3BKNQgNtm1LJS4k8QPe3FFOL8LFUyuKggQIToK2WQKBgQC6\ngRCzDXpld5t4NFQ2Q4CHXpDRv9elLYVpCKKFJe8gPxTz69ZqLcHVgkIi4AwuP8T3\n3gmVWOCz3o0sFLEh5QPWMed99cEUNsDxn/On1IucjhL6XJHJ+P+3Z1+z9SlM+GzI\nnqfcN+aVYHt9z2U5BMzDNwB16NSif1ZFhvuoySQDcQKBgQCTpdDQTm1EOoHeoSgX\njMdQcPy8QNxXPO4QjcRtgaXq3vCm8Q1zMww6O4UyXJq8cyN0b9Cv4fqsXPB69l/v\nvDo+qW2G5ep6Biwzzi4dbXGsIjdzY3S+/wXcr6Sw5fOuG/oD8wmUEV52Ir1AKiZQ\nK2fUx8MvasT3xJhnBNdE1RMC6w==\n-----END PRIVATE KEY-----\n",
      "client_email": "firebase-adminsdk-fbsvc@co-chat-36393.iam.gserviceaccount.com",
      "client_id": "108796029123671428046",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40co-chat-36393.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    });

    final client = await obtainAccessCredentialsViaServiceAccount(
      credentials,
      const [firebaseMsgScope],
      http.Client(),
    );

    Timer.periodic(const Duration(minutes: 59), (timer) {
      client.refreshToken;
    });

    return client.accessToken.data;
  }
}

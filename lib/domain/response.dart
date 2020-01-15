class Response {
  final bool ok;
  final String msg;
  String url;
  int id;
  int status;

  Response(this.ok, this.msg, this.status);

  Response.fromJson(Map<String, dynamic> map)
      : ok = map["id"] != "",
        msg = map["msg"],
        status = map["status"],
        url = map["url"];

  bool isOk() {
    return ok;
  }
}

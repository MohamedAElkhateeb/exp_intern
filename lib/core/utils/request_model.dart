
class Request {
  Request({
    this.status,
    this.response,
    this.url,
    this.header,
    this.body,
    this.actionType,
  });

  String? status;
  String? response;
  String? url;
  String? header;
  String? body;
  String? actionType;

  factory Request.fromJson(Map<String, dynamic> json) => Request(
    status: json["status"],
    response: json["response"],
    url: json["url"],
    header: json["header"],
    body: json["body"],
    actionType: json["actionType"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "response": response,
    "url": url,
    "header": header,
    "body": body,
    "actionType": actionType,
  };
}

List<Request> requestList = [];
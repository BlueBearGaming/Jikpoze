part of bluebear;

typedef ResponseInterface Handle(String code);

abstract class ResponseInterface {
    Handle attachHandle();
    void handleResponse(Map data);
}
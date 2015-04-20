part of bluebear;

class LoadContextResponse {
    Jikpoze.Board board;
    Context context;

    LoadContextResponse.fromJsonData(this.board, var data) {
        context = new Context.fromJsonData(data);
    }
}
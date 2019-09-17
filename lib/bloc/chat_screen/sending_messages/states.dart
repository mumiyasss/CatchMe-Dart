abstract class MessageSendingState {}

class ImagesAreUploading extends MessageSendingState {
    int quantity;

    ImagesAreUploading({this.quantity});
}
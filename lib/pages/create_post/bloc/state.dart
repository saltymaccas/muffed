part of 'bloc.dart';

enum CommunityInfoStatus { initial, loading, failure, success }

class CreatePostState extends Equatable {
  CreatePostState({
    this.isPosting = false,
    this.recipientCommunityInfo,
    this.recipientCommunityInfoStatus = CommunityInfoStatus.initial,
    this.exception,
    this.successfullyPostedPost,
    this.image,
    SplayTreeMap<int, ImageUploadState>? images,
    this.enteredUrl,
  }) : bodyImages = images ?? SplayTreeMap<int, ImageUploadState>();

  final bool isPosting;
  final LemmyCommunity? recipientCommunityInfo;
  final CommunityInfoStatus recipientCommunityInfoStatus;

  final MException? exception;

  /// The resulting post, set when the post gets successfully posted.
  final LemmyPost? successfullyPostedPost;

  /// The image that gets attached to the post.
  final ImageUploadState? image;

  /// images uploaded for the body off the post
  ///
  /// Kept as a splay tree map to keep the order of the images. So they are
  /// correctly refered to
  final SplayTreeMap<int, ImageUploadState> bodyImages;

  /// The url the user can optionally enter that gets attached to the post.
  final String? enteredUrl;

  @override
  List<Object?> get props => [
        isPosting,
        recipientCommunityInfo,
        exception,
        recipientCommunityInfoStatus,
        successfullyPostedPost,
        bodyImages,
        image,
        enteredUrl,
      ];

  CreatePostState copyWith({
    bool? isPosting,
    LemmyCommunity? recipientCommunityInfo,
    CommunityInfoStatus? recipientCommunityInfoStatus,
    MException? exception,
    LemmyPost? successfullyPosted,
    SplayTreeMap<int, ImageUploadState>? images,
    ImageUploadState? image,
    bool setImageToNull = false,
    String? enteredUrl,
    bool setEnteredUrlToNull = false,
  }) {
    return CreatePostState(
      isPosting: isPosting ?? this.isPosting,
      recipientCommunityInfo:
          recipientCommunityInfo ?? this.recipientCommunityInfo,
      exception: exception,
      recipientCommunityInfoStatus:
          recipientCommunityInfoStatus ?? this.recipientCommunityInfoStatus,
      successfullyPostedPost: successfullyPosted ?? successfullyPostedPost,
      images: images ?? bodyImages,
      image: setImageToNull ? null : image ?? this.image,
      enteredUrl: setEnteredUrlToNull ? null : enteredUrl ?? this.enteredUrl,
    );
  }
}

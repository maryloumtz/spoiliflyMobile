class SessionUser {
  SessionUser({
    required this.id,
    required this.email,
    required this.role,
    required this.displayName,
    required this.avatarUrl,
  });

  final String id;
  final String email;
  final String role;
  final String displayName;
  final String? avatarUrl;

  factory SessionUser.fromJson(Map<String, dynamic> json) {
    return SessionUser(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

class UserDirectoryItem {
  UserDirectoryItem({
    required this.id,
    required this.email,
    required this.role,
    required this.displayName,
    required this.avatarUrl,
  });

  final String id;
  final String email;
  final String role;
  final String displayName;
  final String? avatarUrl;

  factory UserDirectoryItem.fromJson(Map<String, dynamic> json) {
    return UserDirectoryItem(
      id: json['id'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }
}

class UsersPayload {
  UsersPayload({required this.users});

  final List<UserDirectoryItem> users;

  factory UsersPayload.fromJson(Map<String, dynamic> json) {
    return UsersPayload(
      users: ((json['users'] as List?) ?? const [])
          .map(
            (item) => UserDirectoryItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class AuthSession {
  AuthSession({
    required this.user,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  final SessionUser user;
  final String accessToken;
  final String tokenType;
  final int expiresIn;

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final auth = json['auth'] as Map<String, dynamic>? ?? <String, dynamic>{};
    return AuthSession(
      user: SessionUser.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: auth['accessToken'] as String? ?? '',
      tokenType: auth['tokenType'] as String? ?? 'Bearer',
      expiresIn: auth['expiresIn'] as int? ?? 0,
    );
  }
}

class Category {
  Category({required this.id, required this.slug, required this.name});

  final String id;
  final String slug;
  final String name;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
    );
  }
}

class Tag {
  Tag({required this.id, required this.slug, required this.name});

  final String id;
  final String slug;
  final String name;

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String,
      slug: json['slug'] as String,
      name: json['name'] as String,
    );
  }
}

class PackSummary {
  PackSummary({
    required this.id,
    required this.title,
    required this.description,
    required this.priceCents,
    required this.spoilCount,
    required this.isOwned,
  });

  final String id;
  final String title;
  final String description;
  final int priceCents;
  final int spoilCount;
  final bool isOwned;

  factory PackSummary.fromJson(Map<String, dynamic> json) {
    return PackSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      priceCents: json['priceCents'] as int,
      spoilCount: json['spoilCount'] as int,
      isOwned: json['isOwned'] as bool? ?? false,
    );
  }
}

class SpoilerSummary {
  SpoilerSummary({
    required this.id,
    required this.title,
    required this.teaser,
    required this.level,
    required this.priceCents,
    required this.isOwned,
    required this.tags,
  });

  final String id;
  final String title;
  final String teaser;
  final String level;
  final int priceCents;
  final bool isOwned;
  final List<Tag> tags;

  factory SpoilerSummary.fromJson(Map<String, dynamic> json) {
    return SpoilerSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      teaser: json['teaser'] as String,
      level: json['level'] as String,
      priceCents: json['priceCents'] as int,
      isOwned: json['isOwned'] as bool? ?? false,
      tags: ((json['tags'] as List?) ?? const [])
          .map((item) => Tag.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class WorkCardView {
  WorkCardView({
    required this.id,
    required this.slug,
    required this.title,
    required this.description,
    required this.type,
    required this.coverImage,
    required this.releaseYear,
    required this.category,
    required this.tags,
    required this.lowestPriceCents,
    required this.spoilerCount,
    required this.pack,
  });

  final String id;
  final String slug;
  final String title;
  final String description;
  final String type;
  final String coverImage;
  final int releaseYear;
  final Category? category;
  final List<Tag> tags;
  final int lowestPriceCents;
  final int spoilerCount;
  final PackSummary? pack;

  factory WorkCardView.fromJson(Map<String, dynamic> json) {
    return WorkCardView(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      coverImage: json['coverImage'] as String,
      releaseYear: json['releaseYear'] as int,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      tags: ((json['tags'] as List?) ?? const [])
          .map((item) => Tag.fromJson(item as Map<String, dynamic>))
          .toList(),
      lowestPriceCents: json['lowestPriceCents'] as int,
      spoilerCount: json['spoilerCount'] as int,
      pack: json['pack'] == null
          ? null
          : PackSummary.fromJson(json['pack'] as Map<String, dynamic>),
    );
  }
}

class MediaItem {
  MediaItem({
    required this.id,
    required this.ownerType,
    required this.ownerId,
    required this.kind,
    required this.url,
    required this.alt,
  });

  final String id;
  final String ownerType;
  final String ownerId;
  final String kind;
  final String url;
  final String alt;

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] as String,
      ownerType: json['ownerType'] as String,
      ownerId: json['ownerId'] as String,
      kind: json['kind'] as String,
      url: json['url'] as String,
      alt: json['alt'] as String,
    );
  }
}

class WorkDetailView extends WorkCardView {
  WorkDetailView({
    required super.id,
    required super.slug,
    required super.title,
    required super.description,
    required super.type,
    required super.coverImage,
    required super.releaseYear,
    required super.category,
    required super.tags,
    required super.lowestPriceCents,
    required super.spoilerCount,
    required super.pack,
    required this.spoilZoneLabel,
    required this.spoilZoneX,
    required this.spoilZoneY,
    required this.spoilers,
    required this.media,
  });

  final String spoilZoneLabel;
  final num spoilZoneX;
  final num spoilZoneY;
  final List<SpoilerSummary> spoilers;
  final List<MediaItem> media;

  factory WorkDetailView.fromJson(Map<String, dynamic> json) {
    return WorkDetailView(
      id: json['id'] as String,
      slug: json['slug'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      coverImage: json['coverImage'] as String,
      releaseYear: json['releaseYear'] as int,
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      tags: ((json['tags'] as List?) ?? const [])
          .map((item) => Tag.fromJson(item as Map<String, dynamic>))
          .toList(),
      lowestPriceCents: json['lowestPriceCents'] as int,
      spoilerCount: json['spoilerCount'] as int,
      pack: json['pack'] == null
          ? null
          : PackSummary.fromJson(json['pack'] as Map<String, dynamic>),
      spoilZoneLabel: json['spoilZoneLabel'] as String,
      spoilZoneX: json['spoilZoneX'] as num,
      spoilZoneY: json['spoilZoneY'] as num,
      spoilers: ((json['spoilers'] as List?) ?? const [])
          .map((item) => SpoilerSummary.fromJson(item as Map<String, dynamic>))
          .toList(),
      media: ((json['media'] as List?) ?? const [])
          .map((item) => MediaItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HomeSpoilerCard extends SpoilerSummary {
  HomeSpoilerCard({
    required super.id,
    required super.title,
    required super.teaser,
    required super.level,
    required super.priceCents,
    required super.isOwned,
    required super.tags,
    required this.workTitle,
    required this.workSlug,
    required this.workCoverImage,
    required this.createdAt,
  });

  final String workTitle;
  final String workSlug;
  final String workCoverImage;
  final String createdAt;

  factory HomeSpoilerCard.fromJson(Map<String, dynamic> json) {
    final work = json['work'] as Map<String, dynamic>;
    return HomeSpoilerCard(
      id: json['id'] as String,
      title: json['title'] as String,
      teaser: json['teaser'] as String,
      level: json['level'] as String,
      priceCents: json['priceCents'] as int,
      isOwned: json['isOwned'] as bool? ?? false,
      tags: ((json['tags'] as List?) ?? const [])
          .map((item) => Tag.fromJson(item as Map<String, dynamic>))
          .toList(),
      workTitle: work['title'] as String,
      workSlug: work['slug'] as String,
      workCoverImage: work['coverImage'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}

class HomePayload {
  HomePayload({
    required this.featured,
    required this.latest,
    required this.latestSpoilers,
    required this.categories,
  });

  final List<WorkCardView> featured;
  final List<WorkCardView> latest;
  final List<HomeSpoilerCard> latestSpoilers;
  final List<Category> categories;

  factory HomePayload.fromJson(Map<String, dynamic> json) {
    return HomePayload(
      featured: ((json['featured'] as List?) ?? const [])
          .map((item) => WorkCardView.fromJson(item as Map<String, dynamic>))
          .toList(),
      latest: ((json['latest'] as List?) ?? const [])
          .map((item) => WorkCardView.fromJson(item as Map<String, dynamic>))
          .toList(),
      latestSpoilers: ((json['latestSpoilers'] as List?) ?? const [])
          .map((item) => HomeSpoilerCard.fromJson(item as Map<String, dynamic>))
          .toList(),
      categories: ((json['categories'] as List?) ?? const [])
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LibraryEntry {
  LibraryEntry({
    required this.work,
    required this.spoilers,
    required this.pack,
  });

  final WorkCardView work;
  final List<SpoilerSummary> spoilers;
  final PackSummary? pack;

  factory LibraryEntry.fromJson(Map<String, dynamic> json) {
    return LibraryEntry(
      work: WorkCardView.fromJson(json['work'] as Map<String, dynamic>),
      spoilers: ((json['spoilers'] as List?) ?? const [])
          .map((item) => SpoilerSummary.fromJson(item as Map<String, dynamic>))
          .toList(),
      pack: json['pack'] == null
          ? null
          : PackSummary.fromJson(json['pack'] as Map<String, dynamic>),
    );
  }
}

class PurchaseHistoryItem {
  PurchaseHistoryItem({
    required this.id,
    required this.productType,
    required this.productTitle,
    required this.workTitle,
    required this.amountCents,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String productType;
  final String productTitle;
  final String workTitle;
  final int amountCents;
  final String status;
  final String createdAt;

  factory PurchaseHistoryItem.fromJson(Map<String, dynamic> json) {
    return PurchaseHistoryItem(
      id: json['id'] as String,
      productType: json['productType'] as String,
      productTitle: json['productTitle'] as String,
      workTitle: json['workTitle'] as String,
      amountCents: json['amountCents'] as int,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}

class ProfilePayload {
  ProfilePayload({
    required this.user,
    required this.bio,
    required this.purchases,
  });

  final SessionUser user;
  final String bio;
  final List<PurchaseHistoryItem> purchases;

  factory ProfilePayload.fromJson(Map<String, dynamic> json) {
    return ProfilePayload(
      user: SessionUser.fromJson(json['user'] as Map<String, dynamic>),
      bio: json['bio'] as String? ?? '',
      purchases: ((json['purchases'] as List?) ?? const [])
          .map(
            (item) =>
                PurchaseHistoryItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class SpoilerDetailView {
  SpoilerDetailView({
    required this.id,
    required this.title,
    required this.teaser,
    required this.level,
    required this.priceCents,
    required this.workTitle,
    required this.workSlug,
    required this.workCoverImage,
    required this.tags,
    required this.media,
    required this.premiumContent,
    required this.isOwned,
    required this.pack,
  });

  final String id;
  final String title;
  final String teaser;
  final String level;
  final int priceCents;
  final String workTitle;
  final String workSlug;
  final String workCoverImage;
  final List<Tag> tags;
  final List<MediaItem> media;
  final String? premiumContent;
  final bool isOwned;
  final PackSummary? pack;

  factory SpoilerDetailView.fromJson(Map<String, dynamic> json) {
    final work = json['work'] as Map<String, dynamic>;
    return SpoilerDetailView(
      id: json['id'] as String,
      title: json['title'] as String,
      teaser: json['teaser'] as String,
      level: json['level'] as String,
      priceCents: json['priceCents'] as int,
      workTitle: work['title'] as String,
      workSlug: work['slug'] as String,
      workCoverImage: work['coverImage'] as String,
      tags: ((json['tags'] as List?) ?? const [])
          .map((item) => Tag.fromJson(item as Map<String, dynamic>))
          .toList(),
      media: ((json['media'] as List?) ?? const [])
          .map((item) => MediaItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      premiumContent: json['premiumContent'] as String?,
      isOwned: json['isOwned'] as bool? ?? false,
      pack: json['pack'] == null
          ? null
          : PackSummary.fromJson(json['pack'] as Map<String, dynamic>),
    );
  }
}

class ChatMessage {
  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.meetingId,
    required this.senderUserId,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String? conversationId;
  final String? meetingId;
  final String senderUserId;
  final String content;
  final String createdAt;

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String?,
      meetingId: json['meetingId'] as String?,
      senderUserId: json['senderUserId'] as String,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
    );
  }
}

class ConversationView {
  ConversationView({
    required this.id,
    required this.participantUserIds,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.participants,
    required this.lastMessage,
  });

  final String id;
  final List<String> participantUserIds;
  final String title;
  final String createdAt;
  final String updatedAt;
  final List<SessionUser> participants;
  final ChatMessage? lastMessage;

  factory ConversationView.fromJson(Map<String, dynamic> json) {
    return ConversationView(
      id: json['id'] as String,
      participantUserIds: ((json['participantUserIds'] as List?) ?? const [])
          .map((item) => item.toString())
          .toList(),
      title: json['title'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      participants: ((json['participants'] as List?) ?? const [])
          .map((item) => SessionUser.fromJson(item as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : ChatMessage.fromJson(json['lastMessage'] as Map<String, dynamic>),
    );
  }
}

class MessagesPayload {
  MessagesPayload({required this.conversations, required this.messages});

  final List<ConversationView> conversations;
  final List<ChatMessage> messages;

  factory MessagesPayload.fromJson(Map<String, dynamic> json) {
    return MessagesPayload(
      conversations: ((json['conversations'] as List?) ?? const [])
          .map(
            (item) => ConversationView.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      messages: ((json['messages'] as List?) ?? const [])
          .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

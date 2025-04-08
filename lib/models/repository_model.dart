class RepositoryModel {
  final int id;
  final String nodeId;
  final String name;
  final String fullName;
  final bool isPrivate;
  final Owner owner;
  final String htmlUrl;
  final String? description;
  final bool fork;
  final String url;
  final String createdAt;
  final String updatedAt;
  final String pushedAt;
  final String gitUrl;
  final String sshUrl;
  final String cloneUrl;
  final String svnUrl;
  final String? homepage;
  final int size;
  final int stargazersCount;
  final int watchersCount;
  final String? language;
  final bool hasIssues;
  final bool hasProjects;
  final bool hasDownloads;
  final bool hasWiki;
  final bool hasPages;
  final bool hasDiscussions;
  final int forksCount;
  final License? license;
  final bool allowForking;
  final bool isTemplate;
  final bool webCommitSignoffRequired;
  final String visibility;
  final int forks;
  final int openIssues;
  final int watchers;
  final String defaultBranch;

  RepositoryModel({
    required this.id,
    required this.nodeId,
    required this.name,
    required this.fullName,
    required this.isPrivate,
    required this.owner,
    required this.htmlUrl,
    this.description,
    required this.fork,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.pushedAt,
    required this.gitUrl,
    required this.sshUrl,
    required this.cloneUrl,
    required this.svnUrl,
    this.homepage,
    required this.size,
    required this.stargazersCount,
    required this.watchersCount,
    this.language,
    required this.hasIssues,
    required this.hasProjects,
    required this.hasDownloads,
    required this.hasWiki,
    required this.hasPages,
    required this.hasDiscussions,
    required this.forksCount,
    this.license,
    required this.allowForking,
    required this.isTemplate,
    required this.webCommitSignoffRequired,
    required this.visibility,
    required this.forks,
    required this.openIssues,
    required this.watchers,
    required this.defaultBranch,
  });

  factory RepositoryModel.fromJson(Map<String, dynamic> json) {
    return RepositoryModel(
      id: json['id'],
      nodeId: json['node_id'] ?? "",
      name: json['name'] ?? "",
      fullName: json['full_name'] ?? "",
      isPrivate: json['private'],
      owner: Owner.fromJson(json['owner']),
      htmlUrl: json['html_url'],
      description: json['description'],
      fork: json['fork'],
      url: json['url'],
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      pushedAt: json['pushed_at'] ?? "",
      gitUrl: json['git_url'],
      sshUrl: json['ssh_url'],
      cloneUrl: json['clone_url'],
      svnUrl: json['svn_url'],
      homepage: json['homepage'],
      size: json['size'],
      stargazersCount: json['stargazers_count'],
      watchersCount: json['watchers_count'],
      language: json['language'],
      hasIssues: json['has_issues'],
      hasProjects: json['has_projects'],
      hasDownloads: json['has_downloads'],
      hasWiki: json['has_wiki'],
      hasPages: json['has_pages'],
      hasDiscussions: json['has_discussions'],
      forksCount: json['forks_count'],
      license:
          json['license'] != null ? License.fromJson(json['license']) : null,
      allowForking: json['allow_forking'],
      isTemplate: json['is_template'],
      webCommitSignoffRequired: json['web_commit_signoff_required'],
      visibility: json['visibility'],
      forks: json['forks'],
      openIssues: json['open_issues'],
      watchers: json['watchers'],
      defaultBranch: json['default_branch'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'node_id': nodeId,
      'name': name,
      'full_name': fullName,
      'private': isPrivate,
      'owner': owner.toJson(),
      'html_url': htmlUrl,
      'description': description,
      'fork': fork,
      'url': url,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'pushed_at': pushedAt,
      'git_url': gitUrl,
      'ssh_url': sshUrl,
      'clone_url': cloneUrl,
      'svn_url': svnUrl,
      'homepage': homepage,
      'size': size,
      'stargazers_count': stargazersCount,
      'watchers_count': watchersCount,
      'language': language,
      'has_issues': hasIssues,
      'has_projects': hasProjects,
      'has_downloads': hasDownloads,
      'has_wiki': hasWiki,
      'has_pages': hasPages,
      'has_discussions': hasDiscussions,
      'forks_count': forksCount,
      'license': license?.toJson(),
      'allow_forking': allowForking,
      'is_template': isTemplate,
      'web_commit_signoff_required': webCommitSignoffRequired,
      'visibility': visibility,
      'forks': forks,
      'open_issues': openIssues,
      'watchers': watchers,
      'default_branch': defaultBranch,
    };
  }
}

class Owner {
  final String login;
  final int id;
  final String nodeId;
  final String avatarUrl;
  final String htmlUrl;

  Owner({
    required this.login,
    required this.id,
    required this.nodeId,
    required this.avatarUrl,
    required this.htmlUrl,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      login: json['login'],
      id: json['id'],
      nodeId: json['node_id'],
      avatarUrl: json['avatar_url'],
      htmlUrl: json['html_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'login': login,
      'id': id,
      'node_id': nodeId,
      'avatar_url': avatarUrl,
      'html_url': htmlUrl,
    };
  }
}

class License {
  final String key;
  final String name;
  final String spdxId;
  final String url;

  License({
    required this.key,
    required this.name,
    required this.spdxId,
    required this.url,
  });

  factory License.fromJson(Map<String, dynamic> json) {
    return License(
      key: json['key'] ?? "",
      name: json['name'] ?? "",
      spdxId: json['spdx_id'] ?? "",
      url: json['url'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'name': name,
      'spdx_id': spdxId,
      'url': url,
    };
  }
}

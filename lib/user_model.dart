class UserModel{
  String? name,email,uid;
  //bool? isAdmin;

  UserModel({required this.email,required this.name,required this.uid});

  UserModel.fromJson(Map<String,dynamic> json){
    this.name = json['name'];
    this.email = json['email'];
    this.uid = json['uid'];
    //this.isAdmin = json['isAdmin'];
  }

  Map<String,dynamic> toMap()=>{
    'name' : this.name,
    'email' : this.email,
    'uid' : this.uid,
    //'isAdmin' : this.isAdmin,
  };

}
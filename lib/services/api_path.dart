class APIPath{
  static String job(String userID, String jobID){
    return 'users/$userID/jobs/$jobID';
  }

  static String jobs(String userID)=> "users/$userID/jobs";
}
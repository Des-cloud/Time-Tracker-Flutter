class APIPath{
  static String job(String userID, String jobID){
    return 'users/$userID/jobs/$jobID';
  }
  static String jobs(String userID)=> "users/$userID/jobs";
  static String entry(String userID, String entryID) =>
      'users/$userID/entries/$entryID';
  static String entries(String userID) => 'users/$userID/entries';
}
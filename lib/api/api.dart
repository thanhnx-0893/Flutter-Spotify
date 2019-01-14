class API {
  static const accessToken = "Bearer BQDXLmXOT0-tufhnYNDgvp87sipXTB6fvy3_Lo0CA-58-FuyQj7Hnd1ZdrEP59ay5kZh9gI6pk6KyYoR9qS0OjE2rDdfSYzdTPvKev933qDZuJM4bgLwv3ljvoN5_VGg-M4Euh2U3lUCwJIMzaHtilKPYZYZ9mbNIs_S4s-EMa8nrzZ0fnSiBoh12V7gqDgFaQUCHPiI-T3185jR8mrsZQaHHdTl9tWya2XMpQYqE48q1LDy5GZ-wLhB0wrhx4eGYkxJNLrvbUMeTA6NSadD";
  static const _baseURL = "https://api.spotify.com";
  static const followingArtistsURL = _baseURL + "/v1/me/following?type=artist&limit=50";
  static const topTracksURL = _baseURL + "/v1/artists/%s/top-tracks?country=VN";
}
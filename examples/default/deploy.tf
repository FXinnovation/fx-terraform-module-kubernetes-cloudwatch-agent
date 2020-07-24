#####
# default example
#####

module "this" {
  source = "../.."

  cluster_name = "fake"
  configuration = {
    agent = {
      region = "us-east-1"
    }
  }
}

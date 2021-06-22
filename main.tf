
module "foo" {
  source = "./modules/test"
  file   = "ls"
}


output "foo" {
  value = module.foo.foo
}


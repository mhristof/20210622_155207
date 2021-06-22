variable "file" {
  default = "file"
}
data "template_file" "foo" {
  template = file("${path.module}/${var.file}.json.tpl")
}

output "foo" {
  value = data.template_file.foo.rendered
}


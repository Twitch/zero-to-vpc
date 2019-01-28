output "ips" {
  value = ["${
  formatlist(
      "Jump instance %s has public elastic IP %s
      ",
      aws_instance.jump.*.tags.Name,
      aws_instance.jump.*.public_ip
    )
  }",
  "${
    formatlist(
      "Instance %s has the following addreses
      Public: %s 
      Private: %s
      ",
      aws_instance.centos7.*.tags.Name,
      aws_instance.centos7.*.public_ip,
      aws_instance.centos7.*.private_ip
    )
  }",
  "${
    formatlist(
      "Instance %s has the following addreses
      Public: %s
      Private: %s
      ",
      aws_instance.centos6.*.tags.Name,
      aws_instance.centos6.*.public_ip,
      aws_instance.centos6.*.private_ip
    )
  }"]
}

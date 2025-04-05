locals {
  dns_writer_name = var.use_custom_writer_name ? var.custom_writer_name : "${var.name}-db.${data.aws_route53_zone.zone.name}"
  dns_reader_name = var.use_custom_reader_name ? var.custom_reader_name : "${var.name}-db-ro.${data.aws_route53_zone.zone.name}"
}


resource "aws_route53_record" "dns_writer" {
  zone_id = data.aws_route53_zone.zone.id
  name    = local.dns_writer_name
  type    = "CNAME"
  ttl     = "60"
  records = [replace(var.writer_endpoint, ":.*$", "")]
}

resource "aws_route53_record" "dns_reader" {
  count   = var.reader_needed ? 1 : 0
  zone_id = data.aws_route53_zone.zone.id
  name    = local.dns_reader_name
  type    = "CNAME"
  ttl     = "60"
  records = [replace(var.reader_endpoint, ":*", "")]

}
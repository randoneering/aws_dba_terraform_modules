resource "aws_route53_record" "dns_writer" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "${var.name}-db.${data.aws_route53_zone.zone.name}"
  type    = "CNAME"
  ttl     = "60"
  records = [var.writer_endpoint]
}

resource "aws_route53_record" "dns_reader" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "${var.name}-db-ro.${data.aws_route53_zone.zone.name}"
  type    = "CNAME"
  ttl     = "60"
  records = [var.reader_endpoint]
}
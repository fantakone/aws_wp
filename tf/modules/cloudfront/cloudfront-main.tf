locals {
  lb_dns_name = "wordpress-lb.${var.region}.elb.amazonaws.com"
}

resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.project_name} CloudFront Distribution"
  default_root_object = "index.php"

  origin {
    domain_name = var.lb_exists ? local.lb_dns_name : "example.com"
    origin_id   = "wordpress-lb"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "wordpress-lb"

    forwarded_values {
      query_string = true
      headers      = ["Host", "Origin", "Access-Control-Request-Headers", "Access-Control-Request-Method"]
      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.php"
  }

  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.php"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-cloudfront-distribution"
    }
  )

  /* Configuration des logs d'accès
  logging_config {
    include_cookies = false
    bucket          = "${var.project_name}-cf-logs.s3.amazonaws.com"
    prefix          = "cloudfront_logs"
  }
  */
}

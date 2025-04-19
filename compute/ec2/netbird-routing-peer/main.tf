module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 8.0"

  name = "netbird-routing-peer"

  desired_capacity = 0
  min_size         = 0
  max_size         = 1

  ignore_desired_capacity_changes = true

  health_check_type   = "EC2"
  vpc_zone_identifier = var.vpc_zone_identifier

  launch_template_name        = "netbird-routing-peer"
  launch_template_description = "Launch template for netbird routing peer"
  update_default_version      = true

  image_id      = var.instance_ami
  instance_type = var.instance_type

  create_iam_instance_profile = true
  iam_role_name               = "netbird-routing-peer"
  iam_role_policies = {
    netbird-routing-peer         = module.iam_policy.arn
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  user_data = base64encode(
    templatefile("${path.module}/files/userdata.sh", {
      secret_name = var.secret_name
      region      = var.aws_region
  }))
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.0"

  name        = "netbird-routing-peer"
  path        = "/system/"
  description = "IAM policy for netbird routing peer instance"

  policy = templatefile("${path.module}/files/iam_policy.json", {
    account_id  = data.aws_caller_identity.this.account_id
    region      = var.aws_region
    secret_name = var.secret_name
    kms_alias   = var.kms_alias
  })
}

module "secrets_manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "~> 1.0"

  name        = var.secret_name
  description = "A secret for netbird routing peer"

  secret_string         = "{}"
  ignore_secret_changes = true
}

# Replace double slashes with a single slash in ARNs.
# With both parameter names "Test" and "/Test", the ARN in the policy must be
# "arn:aws:ssm:*:*:parameter/Test" and not "arn:aws:ssm:*:*:parameter//Test".
locals {
  ssm_get_params_format     = "arn:aws:ssm:${data.aws_region.current[0].name}:${data.aws_caller_identity.current[0].account_id}:parameter/%v"
  ssm_get_params_arns       = formatlist(local.ssm_get_params_format, var.ssm_get_params_names)
  ssm_get_params_arns_fixed = split("|", replace(join("|", local.ssm_get_params_arns), "/parameter\\/\\//", "parameter/"))
}

resource "aws_iam_role_policy" "ssm_get_params" {
  name   = "ssm_get_params"
  count  = var.ssm_get_params && var.enabled ? 1 : 0
  role   = aws_iam_role.default_role[0].id
  policy = data.aws_iam_policy_document.ssm_get_params[0].json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "ssm_get_params" {
  count = var.ssm_get_params && var.enabled ? 1 : 0

  statement {
    actions   = ["ssm:GetParameter"]
    effect    = "Allow"
    resources = local.ssm_get_params_arns_fixed
  }
}

resource "aws_iam_role_policy" "ssm_managed" {
  name   = "ssm_managed"
  count  = (var.ssm_managed || var.ssm_session_manager) && var.enabled ? 1 : 0
  role   = aws_iam_role.default_role[0].id
  policy = data.aws_iam_policy_document.ssm_managed[0].json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "ssm_managed" {
  count = (var.ssm_managed || var.ssm_session_manager) && var.enabled ? 1 : 0

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply",
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation",

    ]
  }
}

resource "aws_iam_role_policy" "ssm_parameter_allow_all" {
  name   = "ssm_parameter_allow_all"
  count  = var.ssmparameter_allowall && var.enabled ? 1 : 0
  role   = aws_iam_role.default_role[0].id
  policy = data.aws_iam_policy_document.ssm_parameter_allow_all[0].json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "ssm_parameter_allow_all" {
  count = var.ssmparameter_allowall && var.enabled ? 1 : 0

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ssm:DeleteParameter",
      "ssm:DescribeParameter",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:PutParameter",
    ]
  }
}

resource "aws_iam_role_policy" "ssm_session_manager" {
  name   = "ssm_session_manager"
  count  = var.ssm_session_manager && var.enabled ? 1 : 0
  role   = aws_iam_role.default_role[0].id
  policy = data.aws_iam_policy_document.ssm_session_manager[0].json

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "ssm_session_manager" {
  count = var.ssm_session_manager && var.enabled ? 1 : 0

  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "s3:GetEncryptionConfiguration",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
    ]
  }
}

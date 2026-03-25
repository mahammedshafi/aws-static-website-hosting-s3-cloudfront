# ============================================================
# iam.tf — IAM Users, Groups, Roles, Policies (Least Privilege)
# ============================================================

# ── IAM ROLE FOR EC2 ────────────────────────────────────────
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
  tags = { Project = var.project_name }
}

# ── EC2 POLICY (S3 Read + CloudWatch) ───────────────────────
resource "aws_iam_policy" "ec2_policy" {
  name        = "${var.project_name}-ec2-policy"
  description = "EC2 access to S3 and CloudWatch"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject", "s3:ListBucket"]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

# ── IAM USER (DevOps Engineer) ───────────────────────────────
resource "aws_iam_user" "devops_user" {
  name = "${var.project_name}-devops-user"
  tags = { Project = var.project_name }
}

# ── IAM GROUP ────────────────────────────────────────────────
resource "aws_iam_group" "devops_group" {
  name = "${var.project_name}-devops-group"
}

resource "aws_iam_group_membership" "devops_membership" {
  name  = "${var.project_name}-group-membership"
  users = [aws_iam_user.devops_user.name]
  group = aws_iam_group.devops_group.name
}

# ── DEVOPS GROUP POLICY ─────────────────────────────────────
resource "aws_iam_group_policy" "devops_group_policy" {
  name  = "${var.project_name}-devops-policy"
  group = aws_iam_group.devops_group.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:*"]
        Resource = "*"
      }
    ]
  })
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "metrics" {
  name       = "metrics"
  namespace  = "kube-system"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"

  # values = [
  #   file("${path.module}/metrics-values.yaml")
  # ]

  set {
    name  = "apiService.create"
    value = "true"
  }
}

resource "helm_release" "dashboard" {
  name       = "dashboard"
  namespace  = "kube-system"
  repository = "https://kubernetes.github.io/dashboard"
  chart      = "kubernetes-dashboard"

}

# Defining VM Volume
resource "libvirt_volume" "rocky9_qcow2" {
  name = var.rocky9_volume_name
  pool = var.rocky9_volume_pool
  #source = "https://download.rockylinux.org/pub/rocky/9.1/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2"
  source = var.rocky9_volume_source
  format = var.rocky9_volume_format
  // size  = var.rocky9_volume_size
}

resource "libvirt_volume" "pagent" {
  name = "pagent"
  pool = var.rocky9_volume_pool
  #source = "https://download.rockylinux.org/pub/rocky/9.1/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2"
  source = var.rocky9_volume_source
  format = var.rocky9_volume_format
  // size  = var.rocky9_volume_size
}

resource "libvirt_volume" "ansible1" {
  name = "ansible1"
  pool = var.rocky9_volume_pool
  #source = "https://download.rockylinux.org/pub/rocky/9.1/images/x86_64/Rocky-9-GenericCloud.latest.x86_64.qcow2"
  source = var.rocky9_volume_source
  format = var.rocky9_volume_format
  // size  = var.rocky9_volume_size
}
data "template_file" "user_data" {
  template = file("${path.module}/user-data")
}

data "template_file" "meta_data" {
  template = file("${path.module}/meta-data")
  vars = {
    instance-id    = "${var.rocky9_name}"
    local-hostname = "${var.rocky9_name}"
  }
}

resource "libvirt_cloudinit_disk" "rocky9_cloudinit_disk" {
  name      = var.rocky9_cloudinit_disk
  pool      = var.rocky9_cloudinit_pool
  user_data = data.template_file.user_data.rendered
  meta_data = data.template_file.meta_data.rendered
}

resource "libvirt_domain" "rocky9" {
  name       = var.rocky9_domain_name
  memory     = var.rocky9_domain_memory
  vcpu       = var.rocky9_domain_vcpu
  qemu_agent = "false"

  network_interface {
    network_name = var.rocky9_network_name
  }

  disk {
    volume_id = libvirt_volume.rocky9_qcow2.id
    // file = libvirt_volume.rocky9_qcow2.id
  }

  cloudinit = libvirt_cloudinit_disk.rocky9_cloudinit_disk.id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  cpu {
    mode = "host-passthrough"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

resource "libvirt_domain" "pagent" {
  name       = "pagent"
  memory     = var.rocky9_domain_memory
  vcpu       = var.rocky9_domain_vcpu
  qemu_agent = "false"

  network_interface {
    network_name = var.rocky9_network_name
  }

  disk {
    volume_id = libvirt_volume.pagent.id
    // file = libvirt_volume.rocky9_qcow2.id
  }

  cloudinit = libvirt_cloudinit_disk.rocky9_cloudinit_disk.id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  cpu {
    mode = "host-passthrough"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}
resource "libvirt_domain" "ansible1" {
  name       = "ansible1"
  memory     = var.rocky9_domain_memory
  vcpu       = var.rocky9_domain_vcpu
  qemu_agent = "false"

  network_interface {
    network_name = var.rocky9_network_name
  }

  disk {
    volume_id = libvirt_volume.ansible1.id
    // file = libvirt_volume.rocky9_qcow2.id
  }

  cloudinit = libvirt_cloudinit_disk.rocky9_cloudinit_disk.id

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  cpu {
    mode = "host-passthrough"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

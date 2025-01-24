# ---------------------------snapshots----------------------------
resource "yandex_compute_snapshot_schedule" "snapshot-daily" {
  name = "snapshot-daily"

  schedule_policy {
    expression = "0 3 * * *"
  }

  retention_period = "168h"
  snapshot_spec {
	  description = "lifetime-snapshot"      
  }

  disk_ids = [yandex_compute_instance.vm1.boot_disk.0.disk_id, yandex_compute_instance.vm2.boot_disk.0.disk_id, yandex_compute_instance.vm3.boot_disk.0.disk_id, yandex_compute_instance.vm4.boot_disk.0.disk_id, yandex_compute_instance.vm5.boot_disk.0.disk_id, yandex_compute_instance.vm6.boot_disk.0.disk_id]
}

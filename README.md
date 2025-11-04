# Hollow OS (Desktop)

After Bazzite setup - run:
  - `sudo bootc switch ghcr.io/dector/hollow-os && systemctl reboot`.
  - ```
      cd $(mktemp -d)
      curl -fsSL \
        https://raw.githubusercontent.com/dector/hollow-os/refs/heads/main/INIT.sh \
        > INIT.sh
      sh INIT.sh
    ```

Changes:

  - Installed [mise](https://mise.jdx.dev/) from
    [COPR](https://copr.fedorainfracloud.org/coprs/jdxcode/mise/).

---

Original (detailed): [README.md](https://github.com/ublue-os/image-template/blob/2adc810c900be571929503e1906f0fb098ad385d/README.md).


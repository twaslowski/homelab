# Known issues

## fluent-bit

If you are seeing the following error in the logs of the fluent-bit pod:

```
Unsupported system page size
```

This is a known issue on Raspberry Pis specifically. It can be fixed by adding the `kernel=kernel8.img` to your
`/boot/firmware/config.txt` file [[source](https://github.com/fluent/fluent-bit/issues/9730#issuecomment-2705240923)].
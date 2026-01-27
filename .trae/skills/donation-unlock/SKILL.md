---
name: "donation-unlock"
description: "实现鲁迅小说游戏的打赏解锁功能，允许用户支付1元及以上解锁所有游戏内容，仅限本机使用。Invoke when user wants to add donation unlock functionality to鲁迅小说游戏."
---

# 打赏解锁技能

## 功能描述

此技能为鲁迅小说游戏实现打赏解锁功能，允许用户通过支付1元人民币及以上的金额来解锁所有游戏内容。解锁状态将存储在本地，仅限本机使用。

## 实现方法

### 1. 添加支付界面

在游戏页面中添加支付按钮和支付状态显示。

### 2. 本地存储解锁状态

使用localStorage存储解锁状态，确保仅限本机使用。

### 3. 解锁所有游戏内容

当用户成功支付后，解锁所有游戏功能和内容。

## 代码实现

### 修改 mintian.html (明天)

在控制面板中添加支付按钮：

```html
<div class="panel-box">
    <strong>💰 打赏解锁</strong>
    <p>支付1元及以上，解锁所有游戏内容</p>
    <button class="btn-play" onclick="showDonationDialog()" id="donation-btn">打赏解锁</button>
    <div id="unlock-status" style="margin-top: 10px; text-align: center; color: var(--gold);"></div>
</div>
```

### 添加JavaScript功能

```javascript
// 检查解锁状态
function checkUnlockStatus() {
    const isUnlocked = localStorage.getItem('luxunGamesUnlocked') === 'true';
    const unlockStatus = document.getElementById('unlock-status');
    const donationBtn = document.getElementById('donation-btn');
    
    if (isUnlocked) {
        if (unlockStatus) unlockStatus.textContent = '✅ 已解锁所有内容';
        if (donationBtn) donationBtn.textContent = '已解锁';
        donationBtn.disabled = true;
    } else {
        if (unlockStatus) unlockStatus.textContent = '🔒 未解锁';
    }
    return isUnlocked;
}

// 显示打赏对话框
function showDonationDialog() {
    // 这里可以实现具体的支付流程
    // 为了演示，我们使用模拟支付
    if (confirm('确认支付1元解锁所有游戏内容？')) {
        // 模拟支付成功
        localStorage.setItem('luxunGamesUnlocked', 'true');
        alert('支付成功！已解锁所有游戏内容');
        checkUnlockStatus();
    }
}

// 页面加载时检查解锁状态
window.addEventListener('DOMContentLoaded', checkUnlockStatus);
```

### 修改其他游戏文件

在其他鲁迅小说游戏文件中添加相同的打赏解锁功能，确保所有游戏都能共享解锁状态。

## 注意事项

1. **仅限本机使用**：解锁状态存储在localStorage中，仅在当前设备有效
2. **支付安全**：实际实现时应使用安全的支付接口
3. **用户体验**：确保支付流程简单明了，解锁后有明确的反馈

## 测试方法

1. 打开任意鲁迅小说游戏页面
2. 点击"打赏解锁"按钮
3. 确认支付
4. 刷新页面，验证是否显示"已解锁"状态
5. 打开其他小说游戏，验证解锁状态是否同步